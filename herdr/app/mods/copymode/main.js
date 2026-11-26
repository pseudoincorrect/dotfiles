// Vim-like copy mode for the focused terminal (like Zellij's scrollback mode).
// keys.json: "terminal": { "cmd-e": "mod.open:copymode" }.
//
// The popup takes the keyboard. The cursor is a one-cell terminal selection.
//   h j k l / arrows   move
//   0 ^ $              line start / line end
//   gg G               top of the history / bottom
//   ctrl-u ctrl-d      page up / page down (also ctrl-b ctrl-f)
//   v V                visual (cell / line), again: back to normal
//   e b                end of the next WORD / start of the WORD (vim E B)
//   /                  search (smart case), enter: go to the next match
//   n N                next / previous match, cyclic
//   y                  copy the selection and exit
//   escape             leave visual, else exit; q exits
//
// Search and e/b read the text with `hc read` and maps it to selection rows: hc joins
// soft-wrapped rows into one line, so a line takes ceil(width / cols) rows.
// The core and the view can keep different amounts of history, so the rows
// are counted from the bottom: terminal.select_all ends on the last cell that
// is not blank, and that is the end of the last line of text.
//
// Herdr runs commands after the call returns, so a selection read right after
// run() is stale. A move in normal mode is an adjust_selection (Herdr clamps it
// and scrolls the view); when the new selection arrives, settle() shrinks it
// back to one cell at its moving end.

import { View, div } from "gpui-kit";
import { h_flex } from "gpui-base";
import { checking, closeOverlay, focused, hc, notify, panes, props, run, terminals, theme } from "herdr";

const MOVES = {
  h: "left", left: "left",
  j: "down", down: "down",
  k: "up", up: "up",
  l: "right", right: "right",
  "0": "line_start", "^": "line_start", home: "line_start",
  $: "line_end", end: "line_end",
  G: "end",
};
const CTRL_MOVES = { u: "page_up", b: "page_up", d: "page_down", f: "page_down" };

const same = (a, b) => a && b && a.row === b.row && a.col === b.col;
const before = (a, b) => a.row < b.row || (a.row === b.row && a.col < b.col);

// Terminal cells of one code point: 2 for wide (CJK, emoji), else 1.
function cells(cp) {
  return (cp >= 0x1100 && cp <= 0x115f) || (cp >= 0x2e80 && cp <= 0xa4cf) ||
    (cp >= 0xac00 && cp <= 0xd7a3) || (cp >= 0xf900 && cp <= 0xfaff) ||
    (cp >= 0xfe30 && cp <= 0xfe4f) || (cp >= 0xff00 && cp <= 0xff60) ||
    (cp >= 0xffe0 && cp <= 0xffe6) || (cp >= 0x1f300 && cp <= 0x1faff) ||
    (cp >= 0x20000 && cp <= 0x3fffd) ? 2 : 1;
}

// The text as lines of {ch, row, col}: hc joins soft-wrapped rows, so a line
// takes ceil(width / cols) rows. Rows start at 0; `rows` is how many there are.
function layout(text, cols) {
  const lines = text.split("\n").map((l) => l.trimEnd());
  while (lines.length && !lines[lines.length - 1]) lines.pop();
  const out = [];
  let row = 0;
  for (const line of lines) {
    const chars = [];
    let width = 0;
    for (const ch of Array.from(line)) {
      chars.push({ ch, row: row + Math.floor(width / cols), col: width % cols });
      width += cells(ch.codePointAt(0));
    }
    out.push(chars);
    row += Math.max(1, Math.ceil(width / cols));
  }
  return { lines: out, rows: row };
}

const cell = (c) => ({ row: c.row, col: c.col });

// Every match of `query` (smart case), as cells, in order.
function findMatches(lines, query) {
  const fold = query === query.toLowerCase();
  const needle = Array.from(fold ? query.toLowerCase() : query);
  const out = [];
  for (const chars of lines) {
    const hay = chars.map((c) => (fold ? c.ch.toLowerCase() : c.ch));
    for (let i = 0; i + needle.length <= hay.length; i++) {
      let ok = true;
      for (let j = 0; j < needle.length && ok; j++) ok = hay[i + j] === needle[j];
      if (ok) out.push(cell(chars[i]));
    }
  }
  return out;
}

// Every WORD (a run of characters that are not blank), as {start, end} cells.
function findWords(lines) {
  const out = [];
  for (const chars of lines) {
    let start = -1;
    for (let i = 0; i <= chars.length; i++) {
      const blank = i === chars.length || /\s/.test(chars[i].ch);
      if (!blank && start < 0) start = i;
      if (blank && start >= 0) {
        out.push({ start: cell(chars[start]), end: cell(chars[i - 1]) });
        start = -1;
      }
    }
  }
  return out;
}

export default class CopyMode extends View {
  init(_props, cx) {
    this.mode = "normal"; // "normal" | "visual" | "line"
    this.pendingG = false;
    this.cur = null; // the cursor cell, once Herdr reports it
    this.anchor = null; // visual: where the selection started
    this.vend = null; // visual: the moving end, when known (else read it)
    this.settling = false;
    this.input = null; // the query while it is typed, else null
    this.searching = false; // a text read is running
    this.text = null; // the last read: { lines, at }
    this.query = "";
    this.status = ""; // "3/12", "no match", ...
    this.handle = cx.focus_handle();
    if (checking()) return;

    this.term = focused()?.terminal;
    if (!this.term) {
      notify({ title: "Copy mode", body: "No focused terminal", level: "warning" });
      this.exit();
      return;
    }
    this.handle.focus();
    cx.timer.after(100, () => this.handle.focus());
    this.settling = true;
    this.cmd("terminal.select", { at: "cursor" });
  }

  async close(_cx) {
    if (this.term) run("terminal.clear_selection", { terminal: this.term });
  }

  cmd(name, args = {}) {
    run(name, { terminal: this.term, ...args });
  }

  exit() {
    closeOverlay(props().overlay);
  }

  selection() {
    return terminals().find((t) => t.address === this.term)?.selection ?? null;
  }

  // Normal mode: when a move arrives, keep one cell at its moving end.
  // `force`: the timer after a move; at an edge the selection does not change.
  settle(force = false) {
    if (!this.settling || this.mode !== "normal") return;
    const s = this.selection();
    if (!s) return;
    if (!force && this.cur && same(s.start, this.cur) && same(s.end, this.cur)) return;
    this.settling = false;
    this.cur = s.end;
    if (!same(s.start, s.end)) this.cmd("terminal.select", { at: s.end });
  }

  move(direction, cx) {
    if (this.mode === "normal") {
      if (!this.cur) return;
      this.settling = true;
    }
    this.vend = null;
    this.cmd("terminal.adjust_selection", { direction });
    // A move at the edge changes nothing, so no live update comes: check again.
    cx.timer.after(150, (cx) => {
      this.settle(true);
      if (this.mode !== "normal" && !this.vend) this.vend = this.selection()?.end ?? null;
      cx.notify();
    });
  }

  visual(mode) {
    if (this.mode === mode) {
      this.mode = "normal";
      if (this.cur) this.cmd("terminal.select", { at: this.cur });
      return;
    }
    const at = this.here();
    if (!at) return;
    this.mode = mode;
    this.anchor = at;
    this.vend = mode === "visual" ? at : null;
    this.cmd("terminal.select", { at, mode: mode === "line" ? "line" : "cell" });
  }

  // The cell a move starts from: the cursor, or the moving end in visual.
  here() {
    if (this.mode === "normal") return this.cur;
    return this.vend ?? this.selection()?.end ?? null;
  }

  // Poll the selection until `ok(selection)`, for at most 1.5 s.
  async waitSelection(cx, ok) {
    for (let i = 0; i < 60; i++) {
      const s = this.selection();
      if (s && ok(s)) return s;
      await cx.sleep(25);
    }
    return null;
  }

  // Read the text, with rows as the selection counts them. A read stays good
  // for 2 s, so quick e/b presses do not read again. select_all changes the
  // selection: after it, the selection is back on the cursor, or in visual on
  // the anchor alone (this.vend is then the anchor).
  async grid(cx) {
    if (this.text && Date.now() - this.text.at < 2000) return this.text.lines;
    const from = this.here();
    const old = this.selection();
    const cols = terminals().find((t) => t.address === this.term)?.cols ?? 80;
    // No history on the alternate screen (vim, less): read only the screen.
    const pane = panes().find((p) => p.terminal === this.term);
    const lines = pane && pane.scroll === null ? "0" : "1000000";
    this.cmd("terminal.select_all");
    const r = JSON.parse((await hc(["read", this.term, "--lines", lines, "--json"])).stdout);
    // Wait for select_all to arrive: the selection changes. It goes from
    // the first to the last cell that is not blank.
    let all = null;
    let changed = false;
    for (let i = 0; i < 60 && !changed; i++) {
      all = this.selection();
      changed = !!all && !(old && same(all.start, old.start) && same(all.end, old.end));
      if (!changed) await cx.sleep(25);
    }
    if (!changed) throw new Error(`select_all ${JSON.stringify(all)}`);
    // Put the selection back: the cursor, or the anchor of visual.
    if (this.mode === "normal") {
      this.cmd("terminal.select", { at: from });
    } else {
      const a = this.anchor;
      this.cmd("terminal.select", { at: a, mode: this.mode === "line" ? "line" : "cell" });
      const s = await this.waitSelection(cx, (s) => this.mode === "line"
        ? s.start.row === a.row && s.end.row === a.row
        : same(s.start, a) && same(s.end, a));
      if (!s) throw new Error("selection did not come back");
      this.vend = s.end;
    }
    const last = before(all.end, all.start) ? all.start : all.end;

    const lay = layout(r.text ?? "", cols);
    const shift = last.row - (lay.rows - 1);
    const shifted = lay.lines
      .map((chars) => chars.map((c) => ({ ch: c.ch, row: c.row + shift, col: c.col })).filter((c) => c.row >= 0))
      .filter((chars) => chars.length);
    this.text = { lines: shifted, at: Date.now() };
    return shifted;
  }

  // Run `job(lines, from)` on the text; it returns the cell to go to, or null.
  withText(cx, job) {
    const from = this.here();
    if (!from || this.searching) return;
    this.searching = true;
    cx.spawn(async (cx) => {
      try {
        const lines = await this.grid(cx);
        // In visual, select_all moved the end to the anchor: go back if no target.
        const to = job(lines, from) ?? (this.mode === "normal" ? null : from);
        if (to && this.mode === "normal") this.goTo(to);
        else if (to) await this.goVisual(to, cx);
      } catch (err) {
        this.status = `failed: ${err?.message ?? err}`;
      } finally {
        this.searching = false;
        cx.notify();
      }
    });
  }

  // Go to the next match of this.query (`reverse`: the previous one), cyclic.
  search(reverse, cx) {
    if (!this.query) return;
    this.text = null; // a search always reads the text again
    this.status = "searching…";
    this.withText(cx, (lines, from) => {
      const found = findMatches(lines, this.query);
      if (!found.length) {
        this.status = `no match: ${this.query}`;
        return null;
      }
      let i = -1;
      if (reverse) for (let j = found.length - 1; j >= 0 && i < 0; j--) { if (before(found[j], from)) i = j; }
      else i = found.findIndex((m) => before(from, m));
      const wrapped = i < 0;
      if (wrapped) i = reverse ? found.length - 1 : 0;
      this.status = `${this.query}  ${i + 1}/${found.length}${wrapped ? "  (wrap)" : ""}`;
      return found[i];
    });
  }

  // vim E (`back` false: end of the next WORD) and B (start of the WORD).
  word(back, cx) {
    this.withText(cx, (lines, from) => {
      const words = findWords(lines);
      if (!back) return words.find((w) => before(from, w.end))?.end ?? null;
      for (let j = words.length - 1; j >= 0; j--) if (before(words[j].start, from)) return words[j].start;
      return null;
    });
  }

  // Normal mode: put the cursor on `to`.
  goTo(to) {
    this.settling = false;
    this.cur = to;
    this.cmd("terminal.select", { at: to });
    // select does not scroll: one step away and back makes the view follow.
    const [a, b] = to.col > 0 ? ["left", "right"] : ["right", "left"];
    this.cmd("terminal.adjust_selection", { direction: a });
    this.cmd("terminal.adjust_selection", { direction: b });
  }

  // Visual: move the end to `to`. Only adjust_selection moves the end and
  // keeps the anchor. Go up or down to the row, read where the end is, then go
  // left or right in that row (line_start can mean the start of a wrapped line).
  async goVisual(to, cx) {
    const from = this.here();
    if (!from) return;
    const dr = to.row - from.row;
    for (let i = 0; i < Math.min(Math.abs(dr), 5000); i++) {
      this.cmd("terminal.adjust_selection", { direction: dr < 0 ? "up" : "down" });
    }
    let end = from;
    if (dr !== 0) {
      const s = await this.waitSelection(cx, (s) => s.end.row === to.row);
      if (!s) throw new Error("the selection did not move");
      end = s.end;
    }
    if (this.mode === "line") {
      this.vend = end;
      return;
    }
    const dc = to.col - end.col;
    for (let i = 0; i < Math.abs(dc); i++) {
      this.cmd("terminal.adjust_selection", { direction: dc < 0 ? "left" : "right" });
    }
    this.vend = to;
  }

  onSearchKey(e, cx) {
    const k = e.key;
    if (k === "escape") {
      this.input = null;
    } else if (k === "enter") {
      if (this.input) this.query = this.input;
      this.input = null;
      this.search(false, cx);
      return;
    } else if (k === "backspace") {
      if (!this.input) this.input = null;
      else this.input = Array.from(this.input).slice(0, -1).join("");
    } else if (e.key_char && !e.modifiers.control && !e.modifiers.platform) {
      this.input += e.key_char;
    }
    cx.notify();
  }

  yank() {
    if (this.mode === "normal") return;
    run("terminal.copy");
    this.exit();
  }

  onKey(e, cx) {
    const k = e.key_char && !e.modifiers.control ? e.key_char : e.key;
    const ctrl = e.modifiers.control;
    cx.stop_propagation();
    if (this.input !== null) return this.onSearchKey(e, cx);
    this.status = "";

    if (k === "/" && !ctrl) {
      this.input = "";
      this.pendingG = false;
      return cx.notify();
    }
    if ((k === "n" || k === "N") && !ctrl) {
      this.search(k === "N", cx);
      return cx.notify();
    }
    if (k === "escape") {
      if (this.mode === "normal") return this.exit();
      const end = this.here();
      this.mode = "normal";
      this.cur = end ?? this.cur;
      if (this.cur) this.cmd("terminal.select", { at: this.cur });
      return cx.notify();
    }
    if (ctrl && CTRL_MOVES[k]) {
      this.move(CTRL_MOVES[k], cx);
    } else if (ctrl) {
      return;
    } else if (k === "g") {
      if (this.pendingG) this.move("home", cx);
      this.pendingG = !this.pendingG;
      return cx.notify();
    } else if (k === "e" || k === "b") {
      this.word(k === "b", cx);
    } else if (MOVES[k]) {
      this.move(MOVES[k], cx);
    } else if (k === "v") {
      this.visual("visual");
    } else if (k === "V") {
      this.visual("line");
    } else if (k === "y") {
      return this.yank();
    } else if (k === "q") {
      return this.exit();
    }
    this.pendingG = false;
    cx.notify();
  }

  render(cx) {
    this.settle();
    const t = theme();
    const label = { normal: "COPY", visual: "VISUAL", line: "V-LINE" }[this.mode];
    const color = this.mode === "normal" ? t.accent : t.done;
    const hint = this.input !== null
      ? "/" + this.input + "▏"
      : this.status || (this.mode === "normal"
        ? "hjkl e b 0 $ gg G ^u ^d · / n N · v V · q exit"
        : "move · / n N · y copy · esc back");
    return h_flex()
      .id("copymode")
      .track_focus(this.handle)
      .on_key_down((e, cx) => this.onKey(e, cx))
      .size_full()
      .px(12)
      .gap(10)
      .items_center()
      .bg(t.popover)
      .text_size(12)
      .child(div().px(6).py(1).rounded(4).bg(color).text_color(t.background).font_semibold().child(label))
      .child(div().text_color(t.foreground).child(this.pendingG ? "g" : ""))
      .child(div().flex_1().truncate().text_color(this.input !== null || this.status ? t.foreground : t.muted).child(hint));
  }
}

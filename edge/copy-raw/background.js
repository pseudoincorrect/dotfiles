// Runs in the page: builds a cleaned copy of the DOM and puts it in the clipboard.
async function copyRaw() {
  const DROP = "script,style,noscript,link,template,iframe,frame,svg,canvas,object,embed,video,audio,source,track,map,dialog:not([open])";
  const KEEP_ATTRS = new Set([
    "href", "src", "alt", "title", "datetime", "colspan", "rowspan",
    "lang", "role", "aria-label", "type", "value", "placeholder", "name", "content",
  ]);
  const VOID_OR_KEEP = new Set(["IMG", "BR", "HR", "INPUT", "TD", "TH", "TEXTAREA", "SELECT", "OPTION"]);

  // Resolve relative URLs and copy live form values before the clone.
  const root = document.documentElement.cloneNode(true);
  const live = document.documentElement.querySelectorAll("a[href],img[src],input,textarea,select");
  const copies = root.querySelectorAll("a[href],img[src],input,textarea,select");
  live.forEach((el, i) => {
    const c = copies[i];
    if (!c) return;
    if (el.tagName === "A") c.setAttribute("href", el.href);
    else if (el.tagName === "IMG") c.setAttribute("src", el.currentSrc || el.src);
    else if ("value" in el && el.type !== "password") c.setAttribute("value", el.value);
  });

  // Head: keep only the title and the description.
  const head = root.querySelector("head");
  if (head) {
    [...head.children].forEach((el) => {
      const keep = el.tagName === "TITLE" ||
        (el.tagName === "META" && /^(description|og:title|og:description|author)$/i
          .test(el.getAttribute("name") || el.getAttribute("property") || ""));
      if (!keep) el.remove();
    });
  }

  root.querySelectorAll(DROP).forEach((el) => el.remove());
  root.querySelectorAll("[hidden],[aria-hidden='true']").forEach((el) => el.remove());

  const walker = document.createTreeWalker(root, NodeFilter.SHOW_ELEMENT | NodeFilter.SHOW_COMMENT | NodeFilter.SHOW_TEXT);
  const comments = [];
  for (let n = walker.currentNode; n; n = walker.nextNode()) {
    if (n.nodeType === Node.COMMENT_NODE) comments.push(n);
    else if (n.nodeType === Node.TEXT_NODE) {
      if (!n.parentElement?.closest("pre,code,textarea")) n.textContent = n.textContent.replace(/\s+/g, " ");
    } else {
      for (const a of [...n.attributes]) {
        const drop = !KEEP_ATTRS.has(a.name) ||
          (a.name === "content" && n.tagName !== "META") ||
          (a.name === "src" && a.value.startsWith("data:")) ||
          a.value.startsWith("javascript:");
        if (drop) n.removeAttribute(a.name);
      }
    }
  }
  comments.forEach((c) => c.remove());

  // Remove empty elements, deepest first.
  [...root.querySelectorAll("body *")].reverse().forEach((el) => {
    if (VOID_OR_KEEP.has(el.tagName)) return;
    if (el.textContent.trim() === "" && !el.querySelector("img,input,textarea,select,br,hr")) el.remove();
  });

  let html = root.outerHTML
    .replace(/<(\/?)(html|head|body|title|meta|div|p|section|article|header|footer|nav|main|aside|ul|ol|li|dl|dt|dd|h[1-6]|table|thead|tbody|tfoot|tr|form|fieldset|blockquote|pre|figure|figcaption|details|summary|hr|br)\b/gi, "\n<$1$2")
    .replace(/[ \t]+\n/g, "\n")
    .replace(/\n{2,}/g, "\n")
    .trim();
  html = `<!-- source: ${location.href} -->\n${html}\n`;

  try {
    await navigator.clipboard.writeText(html);
  } catch {
    const ta = document.createElement("textarea");
    ta.value = html;
    ta.style.cssText = "position:fixed;top:0;left:0;opacity:0";
    document.body.appendChild(ta);
    ta.select();
    const ok = document.execCommand("copy");
    ta.remove();
    if (!ok) throw new Error("clipboard write failed");
  }
  return html.length;
}

async function flash(tabId, text, color) {
  await chrome.action.setBadgeBackgroundColor({ tabId, color });
  await chrome.action.setBadgeText({ tabId, text });
  setTimeout(() => chrome.action.setBadgeText({ tabId, text: "" }), 2000);
}

async function run(tab) {
  if (!tab?.id) return;
  try {
    const [res] = await chrome.scripting.executeScript({ target: { tabId: tab.id }, func: copyRaw });
    const kb = Math.max(1, Math.round(res.result / 1024));
    await flash(tab.id, `${kb}k`, "#2e7d32");
  } catch (e) {
    console.error("copy-raw:", e);
    await flash(tab.id, "ERR", "#c62828");
  }
}

chrome.runtime.onInstalled.addListener(() => {
  chrome.contextMenus.create({ id: "copy-raw", title: "Copy raw HTML", contexts: ["page", "selection", "link", "image"] });
});

chrome.contextMenus.onClicked.addListener((info, tab) => {
  if (info.menuItemId === "copy-raw") run(tab);
});

chrome.action.onClicked.addListener(run);

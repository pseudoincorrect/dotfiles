# Terminal Ctrl shortcuts

Ctrl + letter sends the ASCII control code for that letter (letter code minus 64).
Codes are universal; the actions below are common defaults (readline/tty) and can differ per shell or terminal.

## Cursor movement (readline)

| Key | Action |
|---|---|
| Ctrl+A | Start of line |
| Ctrl+E | End of line |
| Ctrl+B | Back one character |
| Ctrl+F | Forward one character |
| Ctrl+P | Previous history entry (up) |
| Ctrl+N | Next history entry (down) |
| Ctrl+X Ctrl+X | Toggle between start of line and cursor (chord) |

## Editing and deleting

| Key | Action |
|---|---|
| Ctrl+H | Backspace |
| Ctrl+D | Delete character under cursor (or EOF on an empty line) |
| Ctrl+W | Delete word before cursor |
| Ctrl+U | Delete from cursor to start of line (tty kill-line may delete the whole line) |
| Ctrl+K | Delete from cursor to end of line |
| Ctrl+Y | Paste (yank) the last deleted text |
| Ctrl+T | Swap the two characters before the cursor |
| Ctrl+_ | Undo |
| Ctrl+V | Insert the next key literally |

## Enter, Tab and Escape (same code as another key)

| Key | Same as |
|---|---|
| Ctrl+M | Enter (carriage return) |
| Ctrl+J | Enter (line feed) |
| Ctrl+I | Tab |
| Ctrl+[ | Escape |
| Ctrl+? | Delete (127) |

Ctrl+N is NOT Enter. These keys share a code, so a terminal cannot tell them apart unless it supports the kitty keyboard protocol (Kitty, WezTerm).

## History and search

| Key | Action |
|---|---|
| Ctrl+R | Reverse history search |
| Ctrl+G | Cancel the search or the current input |
| Ctrl+O | Run the line, then fetch the next history entry |

## Process control and signals

| Key | Action |
|---|---|
| Ctrl+C | Interrupt (SIGINT) |
| Ctrl+Z | Suspend (SIGTSTP) |
| Ctrl+\ | Quit (SIGQUIT) |
| Ctrl+D | End of input (EOF) |
| Ctrl+T | SIGINFO on macOS, when the shell isn't using it for transpose |
| Ctrl+Y | Delayed suspend on macOS, if the shell isn't using it for yank |

## Terminal output

| Key | Action |
|---|---|
| Ctrl+S | Pause output (XOFF) |
| Ctrl+Q | Resume output (XON) |
| Ctrl+L | Clear screen or redraw |
| Ctrl+G | Bell |

## Vim and Neovim extras

| Key | Action |
|---|---|
| Ctrl+] | Jump to tag |
| Ctrl+^ | Alternate file |
| Ctrl+@ / Ctrl+Space | Insert previously inserted text and leave insert mode (Vim insert mode) |

## Rare or unused

| Key | Notes |
|---|---|
| Ctrl+X | Prefix for readline chords |
| Ctrl+@ | NUL; set mark in Emacs and readline |

Some keys appear under several headings because they do several jobs: Ctrl+D (delete and EOF), Ctrl+G (cancel and bell), Ctrl+T and Ctrl+Y (shell vs tty meaning).

-- Multiple cursors, built in since Neovim 0.13 (see :help multicursor).
-- Native keys: Q toggle, {Visual}Q one per line, zq{motion}, ]C / [C jump,
-- CTRL-L clear, gQ restore, q= follow mode, <C-LeftMouse> toggle.
-- The <C-A-*> keymaps below keep the keys of the old multicursor.nvim plugin.

local ns = vim.api.nvim_create_namespace 'nvim.multicursor'
local set = vim.keymap.set

local function has_cursors()
  return #vim.api.nvim_buf_get_extmarks(0, ns, 0, -1, { limit = 1 }) > 0
end

local function add_cursor_here()
  local pos = vim.api.nvim_win_get_cursor(0)
  vim.api.nvim_buf_set_extmark(0, ns, pos[1] - 1, pos[2], {})
end

-- The keymaps below turn on 'follow' mode after they add cursors, so motions
-- (e, w, f, ...) move all cursors, not only the primary one.

-- Search pattern for the visual selection (single line), or the word under
-- the cursor. In Visual mode, also go back to Normal mode at the selection start.
local function match_pattern()
  local mode = vim.fn.mode()
  if mode == 'v' or mode == 'V' or mode == '\22' then
    local text = table.concat(vim.fn.getregion(vim.fn.getpos 'v', vim.fn.getpos '.', { type = mode }), '\n')
    vim.cmd 'normal! \27'
    vim.cmd 'normal! `<'
    return '\\V' .. vim.fn.escape(text, '\\'):gsub('\n', '\\n')
  end
  return '\\<' .. vim.fn.expand '<cword>' .. '\\>'
end

-- Put a cursor on the current match (unless skip), then move to the next
-- match. The 'w' flag wraps past the end of the buffer (options.lua sets
-- wrapscan = false).
local function match_next(skip)
  return function()
    if vim.v.cascading then
      return
    end
    local mode = vim.fn.mode()
    local pat = vim.fn.getreg '/'
    if not has_cursors() or mode ~= 'n' then
      pat = match_pattern()
      vim.fn.setreg('/', pat)
      vim.fn.search(pat, 'bcW') -- go to the start of the current match
    end
    if not skip then
      add_cursor_here()
    end
    vim.fn.search(pat, 'w')
    vim.o.hlsearch = true
    vim.bo.follow = true
  end
end

local function match_all()
  if vim.v.cascading then
    return
  end
  local pat = match_pattern()
  vim.fn.setreg('/', pat)
  for _, m in ipairs(vim.fn.matchbufline('%', pat, 1, '$')) do
    vim.api.nvim_buf_set_extmark(0, ns, m.lnum - 1, m.byteidx, {})
  end
  vim.bo.follow = true
end

-- Add / skip cursors by matching the word under cursor (or the visual selection)
set({ 'n', 'x' }, '<C-A-n>', match_next(false), { desc = 'MC: add next match' })
set({ 'n', 'x' }, '<C-A-x>', match_next(true), { desc = 'MC: skip to next match' })
set({ 'n', 'x' }, '<C-A-a>', match_all, { desc = 'MC: add all matches' })

-- Add cursors on adjacent lines
set('n', '<C-A-j>', '1Qj<Cmd>setlocal follow<CR>', { desc = 'MC: add cursor below' })
set('n', '<C-A-k>', '1Qk<Cmd>setlocal follow<CR>', { desc = 'MC: add cursor above' })

-- Toggle a cursor under the current position, or with the mouse
set('n', '<C-A-q>', 'Q', { desc = 'MC: toggle cursor' })
set('n', '<C-A-LeftMouse>', '<C-LeftMouse>', { desc = 'MC: toggle cursor (mouse)' })

-- Visual selection -> one cursor per line
set('x', '<C-A-i>', 'Q', { desc = 'MC: cursor per selected line' })

-- Move between cursors, delete the current one
set('n', '<C-A-h>', '[C', { desc = 'MC: previous cursor' })
set('n', '<C-A-l>', ']C', { desc = 'MC: next cursor' })
set('n', '<C-A-d>', ']C2Q', { desc = 'MC: delete cursor' })

-- <Esc> clears the cursors when there are some (same as CTRL-L)
set('n', '<Esc>', function()
  return has_cursors() and '<C-L>' or '<Esc>'
end, { expr = true, remap = true, desc = 'MC: clear cursors' })

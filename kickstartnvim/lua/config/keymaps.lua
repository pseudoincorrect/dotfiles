-- Keybinding Configuration
local M = {}

function M.setup()
  -- Window management (Ctrl+w equivalents)
  vim.keymap.set('n', '<leader>wh', '<C-w>h', { desc = 'Move to left window' })
  vim.keymap.set('n', '<C-h>', '<C-w>h', { desc = 'Move to left window' })
  vim.keymap.set('n', '<leader>wl', '<C-w>l', { desc = 'Move to right window' })
  vim.keymap.set('n', '<C-l>', '<C-w>l', { desc = 'Move to right window' })
  vim.keymap.set('n', '<leader>wj', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
  vim.keymap.set('n', '<leader>wk', '<C-w><C-k>', { desc = 'Move focus to the upper window' })
  vim.keymap.set('n', '<leader>ww', '<C-w>w', { desc = 'Switch to next window' })
  vim.keymap.set('n', '<leader>wp', '<C-w>p', { desc = 'Switch to previous window' })
  vim.keymap.set('n', '<leader>wv', '<C-w>v', { desc = 'Split window vertically' })
  vim.keymap.set('n', '<leader>ws', '<C-w>s', { desc = 'Split window horizontally' })
  vim.keymap.set('n', '<leader>wc', '<C-w>c', { desc = 'Close window' })
  vim.keymap.set('n', '<leader>wd', ':bp|bd #<CR>', { desc = 'Close current buffer' })
  vim.keymap.set('n', '<C-w>d', ':bp|bd #<CR>', { desc = 'Close current buffer' })
  vim.keymap.set('n', '<leader>wa', ':%bd!<CR>', { desc = 'Close all buffers' })
  vim.keymap.set('n', '<C-w>a', ':%bd!<CR>', { desc = 'Close all buffers' })
  vim.keymap.set('n', '<leader>wo', '<C-w>o', { desc = 'Close all other windows' })
  vim.keymap.set('n', '<leader>wq', '<C-w>q', { desc = 'Quit current window' })
  vim.keymap.set('n', '<leader>w=', '<C-w>=', { desc = 'Equalize window sizes' })
  vim.keymap.set('n', '<leader>w+', '<C-w>+', { desc = 'Increase window height' })
  vim.keymap.set('n', '<leader>w-', '<C-w>-', { desc = 'Decrease window height' })
  vim.keymap.set('n', '<leader>w<', '<C-w><', { desc = 'Decrease window width' })
  vim.keymap.set('n', '<leader>w>', '<C-w>>', { desc = 'Increase window width' })
  vim.keymap.set('n', '<leader>wT', '<C-w>T', { desc = 'Move window to new tab' })
  vim.keymap.set('n', '<leader>wr', '<C-w>r', { desc = 'Rotate windows' })
  vim.keymap.set('n', '<leader>wR', '<C-w>R', { desc = 'Rotate windows reverse' })
  vim.keymap.set('n', '<leader>wx', '<C-w>x', { desc = 'Exchange windows' })

  -- File operations
  vim.api.nvim_set_keymap('n', '<C-s>', ':w<CR>', { noremap = true, silent = true, desc = 'Save the current file' })
  vim.api.nvim_set_keymap('i', '<C-s>', '<Esc>:w<CR>', { noremap = true, silent = true, desc = 'Save the current file' })
  vim.keymap.set('n', '<leader>v', ':vert term<CR>', { noremap = true, silent = true, desc = 'Open a Terminal in vsplit' })

  -- Yanky keybindings
  vim.keymap.set({ 'n', 'x' }, 'p', '<Plug>(YankyPutAfter)')
  vim.keymap.set({ 'n', 'x' }, 'P', '<Plug>(YankyPutBefore)')
  vim.keymap.set({ 'n', 'x' }, 'gp', '<Plug>(YankyGPutAfter)')
  vim.keymap.set({ 'n', 'x' }, 'gP', '<Plug>(YankyGPutBefore)')
  vim.keymap.set('n', '<c-p>', '<Plug>(YankyPreviousEntry)')
  vim.keymap.set('n', '<c-n>', '<Plug>(YankyNextEntry)')

  -- NeoTree
  vim.keymap.set('n', '<leader>ee', '<Esc>:Neotree toggle<CR>', { noremap = true, desc = 'Open NeoTree' })
  vim.keymap.set('n', '<leader>eb', '<Esc>:Neotree toggle source=buffers<CR>', { noremap = true, desc = 'Open NeoTree Buffers' })

  -- Path copy operations
  vim.keymap.set('n', '<leader>er', function()
    local path = vim.fn.expand '%:.'
    vim.fn.setreg('+', path)
    print('Copied relative path: ' .. path)
  end, { desc = 'Copy relative path to clipboard' })
  vim.keymap.set('n', '<leader>ea', function()
    local path = vim.fn.expand '%:p'
    vim.fn.setreg('+', path)
    print('Copied absolute path: ' .. path)
  end, { desc = 'Copy absolute path to clipboard' })

  -- Fixed: Change word under cursor with better mapping
  vim.keymap.set('n', '<leader>cw', 'ciw', { desc = 'Change word under cursor' })

  -- Ensure Escape works to exit insert mode
  vim.keymap.set('i', '<Esc>', '<Esc>', { noremap = true, silent = true })

  -- Delete without yanking
  vim.keymap.set({ 'n', 'v' }, 'd', '"_d', { desc = 'Delete without yanking' })
  vim.keymap.set({ 'n', 'v' }, 'x', '"_x', { desc = 'Delete character without yanking' })
  vim.keymap.set({ 'n', 'v' }, 'c', '"_c', { desc = 'Change without yanking' })

  -- Better defaults
  vim.keymap.set({ 'n', 'v' }, 'U', '<C-r>', { desc = 'Redo' })
  vim.keymap.set({ 'n', 'v', 'o' }, 'gl', 'g_', { desc = 'Go to end of line' })
  vim.keymap.set({ 'n', 'v', 'o' }, 'gh', '^', { desc = 'Go to beginning of line' })
  vim.keymap.set({ 'n', 'v', 'o' }, 'ge', 'G', { desc = 'Go to end of file' })
  vim.keymap.set({ 'n', 'v', 'o' }, 'ga', 'ggVG', { desc = 'Select all' })
  vim.keymap.set({ 'n' }, 'ga', 'ggVG', { desc = 'Select all' })
  vim.keymap.set({ 'v', 'o' }, 'ga', 'gg<Esc>VG', { desc = 'Select all' })

  -- Fixed: Better visual mode navigation
  vim.keymap.set('v', 'J', 'j', { desc = 'Move down in visual mode' })
  vim.keymap.set('v', 'K', 'k', { desc = 'Move up in visual mode' })
  vim.keymap.set('n', '<leader>v', 'V', { desc = 'Visual line' })

  -- macro recording and playback
  vim.keymap.set('n', 'Q', '@q', { desc = 'Repeat q macro' })

  -- Note: m key is now handled by flash.nvim for f/F/t/T repeat functionality

  -- Alternative: use comma as backup (normally reverse f/F/t/T search)
  vim.api.nvim_set_keymap('n', 'm', ';', { noremap = true, silent = true })
  vim.api.nvim_set_keymap('v', 'm', ';', { noremap = true, silent = true })
  vim.api.nvim_set_keymap('o', 'm', ';', { noremap = true, silent = true })

  -- Keep f/s scroll navigation as requested
  vim.keymap.set('n', '<C-j>', '<C-d>', { desc = 'Half page down' })
  vim.keymap.set('n', '<C-k>', '<C-u>', { desc = 'Half page up' })

  -- Line manipulation
  vim.keymap.set('n', '<leader>o', 'o<Esc>k', { desc = 'Line Below' })
  vim.keymap.set('n', '<leader>O', 'O<Esc>j', { desc = 'Line Above' })

  -- System clipboard
  vim.keymap.set('v', '<leader>y', '"+y', { desc = 'Yank' })
  vim.keymap.set('n', '<leader>Y', '"+yg_', { desc = 'Yank Line' })
  vim.keymap.set('n', '<leader>y', '"+y', { desc = 'Yank' })
  -- vim.keymap.set('n', '<leader>yy', '"+yy', { desc = 'Yank entire line to system clipboard' })
  vim.keymap.set({ 'n', 'v' }, '<leader>p', '"+p', { desc = 'Paste' })
  vim.keymap.set({ 'n', 'v' }, '<leader>P', '"+P', { desc = 'Paste Before' })

  -- LSP
  vim.keymap.set('n', '<leader>ch', vim.lsp.buf.hover, { desc = 'LSP Hover' })
end

return M

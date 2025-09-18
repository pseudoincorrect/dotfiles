-- Keybinding Configuration
local M = {}

function M.setup()
  -- Window management (Ctrl+w equivalents)
  vim.keymap.set({ 'n', 'i', 'v' }, '<C-h>', '<Esc><C-w>h', { desc = 'Move to left window' })
  vim.keymap.set({ 'n', 'i', 'v' }, '<C-l>', '<Esc><C-w>l', { desc = 'Move to right window' })
  vim.keymap.set('n', '<C-w>a', ':%bd!<CR>', { desc = 'Close all buffers' })
  vim.keymap.set('n', '<C-w>d', ':bp|bd #<CR>', { desc = 'Close current buffer' })
  vim.keymap.set('n', '<leader>wh', '<C-w>h', { desc = 'Move to left window' })
  vim.keymap.set('n', '<leader>wl', '<C-w>l', { desc = 'Move to right window' })
  vim.keymap.set('n', '<leader>wj', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
  vim.keymap.set('n', '<leader>wk', '<C-w><C-k>', { desc = 'Move focus to the upper window' })
  vim.keymap.set('n', '<leader>ww', '<C-w>w', { desc = 'Switch to next window' })
  vim.keymap.set('n', '<leader>wp', '<C-w>p', { desc = 'Switch to previous window' })
  vim.keymap.set('n', '<leader>wv', '<C-w>v', { desc = 'Split window vertically' })
  vim.keymap.set('n', '<leader>ws', '<C-w>s', { desc = 'Split window horizontally' })
  vim.keymap.set('n', '<leader>wc', '<C-w>c', { desc = 'Close window' })
  vim.keymap.set('n', '<leader>wd', ':bp|bd #<CR>', { desc = 'Close current buffer' })
  vim.keymap.set('n', '<leader>wa', ':%bd!<CR>', { desc = 'Close all buffers' })
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

  -- Redraw screen
  vim.keymap.set('n', '<leader><leader>', ':e!<CR>', { desc = 'Reload files' })

  -- Ctrl+s to save
  vim.api.nvim_set_keymap('n', '<C-s>', ':w<CR>', { noremap = true, silent = true, desc = 'Save the current file' })
  vim.api.nvim_set_keymap('i', '<C-s>', '<Esc>:w<CR>', { noremap = true, silent = true, desc = 'Save the current file' })

  -- Yanky keybindings
  vim.keymap.set({ 'n', 'x' }, 'p', '<Plug>(YankyPutAfter)')
  vim.keymap.set({ 'n', 'x' }, 'P', '<Plug>(YankyPutBefore)')
  vim.keymap.set({ 'n', 'x' }, 'gp', '<Plug>(YankyGPutAfter)')
  vim.keymap.set({ 'n', 'x' }, 'gP', '<Plug>(YankyGPutBefore)')
  vim.keymap.set('n', '<c-p>', '<Plug>(YankyPreviousEntry)')
  vim.keymap.set('n', '<c-n>', '<Plug>(YankyNextEntry)')

  -- NeoTree
  vim.keymap.set('n', '<leader>er', '<Esc>:Neotree reveal<CR>', { noremap = true, desc = 'NeoTree Reveal' })
  vim.keymap.set('n', '<leader>ec', '<Esc>:Neotree close<CR>', { noremap = true, desc = 'NeoTree Close' })
  vim.keymap.set('n', '<leader>ee', '<Esc>:Neotree float<CR>', { noremap = true, desc = 'NeoTree Float' })

  -- Path copy operations
  vim.keymap.set('n', '<leader>pr', function()
    local path = vim.fn.expand '%:.'
    vim.fn.setreg('+', path)
    print('Copied relative path: ' .. path)
  end, { desc = 'Copy relative path' })
  vim.keymap.set('n', '<leader>pa', function()
    local path = vim.fn.expand '%:p'
    vim.fn.setreg('+', path)
    print('Copied absolute path: ' .. path)
  end, { desc = 'Copy absolute path' })

  -- Ensure Escape works to exit insert mode
  vim.keymap.set('i', '<Esc>', '<Esc>', { noremap = true, silent = true })

  -- Terminal mode keymaps
  vim.keymap.set('t', '<C-h>', '<C-\\><C-n><C-w>h', { desc = 'Move to left window from terminal' })
  vim.keymap.set('t', '<C-l>', '<C-\\><C-n><C-w>l', { desc = 'Move to right window from terminal' })
  vim.keymap.set('t', '<C-Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode to normal mode' })

  -- Terminal management
  vim.keymap.set('n', '<leader>tt', ':term<CR>', { desc = 'Open terminal' })
  vim.keymap.set('n', '<leader>tv', ':vert term<CR>', { desc = 'Open Vsplit terminal' })
  vim.keymap.set('n', '<leader>tr', function()
    local name = vim.fn.input 'Terminal name: '
    if name ~= '' then
      vim.cmd('file term://' .. name)
    end
  end, { desc = 'Rename terminal' })

  -- No yank operations
  vim.keymap.set({ 'n', 'v' }, 'd', '"_d', { desc = 'd no yank' })
  vim.keymap.set({ 'n', 'v' }, 'D', '"_D', { desc = 'D no yank' })
  vim.keymap.set({ 'n', 'v' }, 'x', '"_x', { desc = 'x no yank' })
  vim.keymap.set({ 'n', 'v' }, 'c', '"_c', { desc = 'c no yank' })
  vim.keymap.set({ 'n', 'v' }, 'C', '"_c', { desc = 'C no yank' })

  -- Yank operations
  vim.keymap.set({ 'n', 'v' }, '<leader>yd', 'd', { desc = 'd yank' })
  vim.keymap.set({ 'n', 'v' }, '<leader>yD', 'D', { desc = 'D yank' })
  vim.keymap.set({ 'n', 'v' }, '<leader>yx', 'x', { desc = 'x yank' })
  vim.keymap.set({ 'n', 'v' }, '<leader>yc', 'c', { desc = 'c yank' })
  vim.keymap.set({ 'n', 'v' }, '<leader>yC', 'C', { desc = 'C yank' })
  vim.keymap.set({ 'n', 'v' }, '<leader>ys', 'S', { desc = 'S yank' })

  -- Better defaults
  vim.keymap.set({ 'n', 'v' }, 'U', '<C-r>', { desc = 'Redo' })
  vim.keymap.set({ 'n', 'v', 'o' }, 'gl', 'g_', { desc = 'Go to end of line' })
  vim.keymap.set({ 'n', 'v', 'o' }, 'gh', '^', { desc = 'Go to beginning of line' })
  vim.keymap.set({ 'n', 'v', 'o' }, 'ga', 'ggVG', { desc = 'Select all' })
  vim.keymap.set({ 'n', 'v', 'o' }, 'ge', 'G', { desc = 'Select all' })
  vim.keymap.set({ 'n' }, 'ga', 'ggVG', { desc = 'Select all' })
  vim.keymap.set({ 'v', 'o' }, 'ga', 'gg<Esc>VG', { desc = 'Select all' })

  -- Fixed: Better visual mode navigation
  vim.keymap.set('n', '<leader>v', 'V', { desc = 'Visual line' })

  -- macro recording and playback
  vim.keymap.set('n', 'Q', '@q', { desc = 'Repeat q macro' })

  -- Keep scroll navigation
  vim.keymap.set('n', '<C-d>', '<C-d>zz', { desc = 'Scroll down' })
  vim.keymap.set('n', '<C-u>', '<C-u>zz', { desc = 'Scroll up' })
  vim.keymap.set('n', '<C-j>', '2<C-e>', { desc = 'Scroll down' })
  vim.keymap.set('n', '<C-k>', '2<C-y>', { desc = 'Scroll up' })
  -- vim.keymap.set('n', 'J', '<C-e>', { desc = 'Scroll down' })
  -- vim.keymap.set('n', 'K', '<C-y>', { desc = 'Scroll up' })

  -- Line manipulation
  vim.keymap.set('n', '<leader>o', 'o<Esc>k', { desc = 'Line Below' })
  vim.keymap.set('n', '<leader>O', 'O<Esc>j', { desc = 'Line Above' })

  -- Better movement for wrapped lines
  vim.keymap.set({ 'n', 'x' }, 'j', function()
    return vim.v.count > 0 and 'j' or 'gj'
  end, { noremap = true, expr = true })
  vim.keymap.set({ 'n', 'x' }, 'k', function()
    return vim.v.count > 0 and 'k' or 'gk'
  end, { noremap = true, expr = true })

  -- Visual selection search
  vim.keymap.set('x', '*', 'y/\\V<C-r>"<CR>', { desc = 'Search visual selection forward' })
  vim.keymap.set('x', '#', 'y?\\V<C-r>"<CR>', { desc = 'Search visual selection backward' })

  -- Custom search behavior - Esc to stay, Ctrl+Esc to cancel
  vim.keymap.set('n', '/', '/\\V', { desc = 'Search forward and stay on Esc' })
  vim.keymap.set('n', '?', '?\\V', { desc = 'Search backward and stay on Esc' })
  vim.keymap.set('c', '<Esc>', '<CR>', { desc = 'Accept search and stay' })
  vim.keymap.set('c', '<C-Esc>', '<C-c>', { desc = 'Cancel search' })

  -- LSP
  vim.keymap.set('n', '<leader>ch', vim.lsp.buf.hover, { desc = 'LSP Hover' })
end

return M

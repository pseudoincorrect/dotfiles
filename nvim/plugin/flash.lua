-- Quick navigation with flash.nvim
local gh = function(r)
  return 'https://github.com/' .. r
end

vim.pack.add { gh 'folke/flash.nvim' }

require('flash').setup {}

vim.keymap.set({ 'n', 'x', 'o' }, 's', function()
  require('flash').jump()
end, { desc = 'Flash search' })

-- Make labels stand out (re-applied after every colorscheme change)
local function set_label_hl()
  vim.api.nvim_set_hl(0, 'FlashLabel', { fg = '#ffffff', bg = '#ff007c', bold = true })
end
set_label_hl()
vim.api.nvim_create_autocmd('ColorScheme', { callback = set_label_hl })

vim.keymap.set({ 'n', 'x', 'o' }, '<A-s>', function()
  require('flash').treesitter()
end, { desc = 'Flash Treesitter' })

vim.keymap.set('o', 'r', function()
  require('flash').remote()
end, { desc = 'Remote Flash' })

vim.keymap.set({ 'o', 'x' }, '<C-v>', function()
  require('flash').treesitter_search()
end, { desc = 'Treesitter Search' })

vim.keymap.set('n', 'gS', function()
  require('flash').jump {
    action = function(match, state)
      state:hide()
      vim.api.nvim_set_current_win(match.win)
      vim.api.nvim_win_set_cursor(match.win, match.pos)
      vim.lsp.buf.definition()
    end,
  }
end, { desc = 'Flash Go to Definition' })

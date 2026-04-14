-- Persistent file bookmarks with grapple.nvim
local gh = function(r)
  return 'https://github.com/' .. r
end

vim.pack.add { gh 'cbochs/grapple.nvim' }

require('grapple').setup {
  scope = 'git',
  style = 'basename',
  win_opts = {
    width = 80,
    height = 25,
  },
}

vim.keymap.set('n', '<leader>G', '<cmd>Grapple toggle<cr>', { desc = 'Grapple toggle' })
vim.keymap.set('n', '<leader>g', '<cmd>Grapple toggle_tags<cr>', { desc = 'Grapple window' })
vim.keymap.set({ 'n', 'i', 't' }, '<C-g>', '<cmd>Grapple toggle_tags<cr>', { desc = 'Grapple window' })

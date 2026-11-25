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

local function toggle()
  require('grapple').toggle()
  -- Show or hide the tag mark in the winbar (lua/config/options.lua)
  vim.cmd 'redrawstatus!'
end

vim.keymap.set('n', '<leader>G', toggle, { desc = 'Grapple toggle' })
vim.keymap.set('n', '<C-h>', toggle, { desc = 'Grapple toggle' })
vim.keymap.set('n', '<C-l>', '<cmd>Grapple toggle_tags<cr>', { desc = 'Grapple window' })
vim.keymap.set('n', '<C-j>', '<cmd>Grapple cycle_tags next<cr>', { desc = 'Grapple next tag' })
vim.keymap.set('n', '<C-k>', '<cmd>Grapple cycle_tags prev<cr>', { desc = 'Grapple previous tag' })
vim.keymap.set('n', '<leader>g', '<cmd>Grapple toggle_tags<cr>', { desc = 'Grapple window' })
vim.keymap.set({ 'n', 'i', 't' }, '<C-g>', '<cmd>Grapple toggle_tags<cr>', { desc = 'Grapple window' })

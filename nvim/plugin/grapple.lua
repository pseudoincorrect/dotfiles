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
  -- Show or hide the tag mark in the explorer (plugin/snacks.lua)
  for _, picker in ipairs(Snacks.picker.get { source = 'explorer' }) do
    picker.list.dirty = true
    picker.list:update()
  end
end

vim.keymap.set('n', '<leader>G', toggle, { desc = 'Grapple toggle' })
-- Same actions on <C-x> and <leader>x
for _, key in ipairs { '<C-%s>', '<leader>%s' } do
  vim.keymap.set('n', key:format 'h', toggle, { desc = 'Grapple toggle' })
  vim.keymap.set('n', key:format 'l', '<cmd>Grapple toggle_tags<cr>', { desc = 'Grapple window' })
  vim.keymap.set('n', key:format 'j', '<cmd>Grapple cycle_tags next<cr>', { desc = 'Grapple next tag' })
  vim.keymap.set('n', key:format 'k', '<cmd>Grapple cycle_tags prev<cr>', { desc = 'Grapple previous tag' })
end
vim.keymap.set('n', '<leader>g', '<cmd>Grapple toggle_tags<cr>', { desc = 'Grapple window' })
vim.keymap.set({ 'n', 'i', 't' }, '<C-g>', '<cmd>Grapple toggle_tags<cr>', { desc = 'Grapple window' })

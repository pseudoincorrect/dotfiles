-- Leader keys (must be set before plugins load)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Nerd Font support
vim.g.have_nerd_font = true

-- Enable bytecode cache for faster startup
vim.loader.enable()

-- Neovide configuration
if vim.g.neovide then
  vim.g.neovide_scale_factor = 0.65
  -- paste with ctrl+shift+v
  vim.keymap.set({ 'n', 'v', 's', 'x', 'o', 'i', 'l', 'c', 't' }, '<C-S-v>', function()
    vim.api.nvim_paste(vim.fn.getreg '+', true, -1)
  end, { noremap = true, silent = true })
  vim.keymap.set({ 'n', 'v' }, '<C-=>', ':lua vim.g.neovide_scale_factor = vim.g.neovide_scale_factor + 0.1<CR>')
  vim.keymap.set({ 'n', 'v' }, '<C-->', ':lua vim.g.neovide_scale_factor = vim.g.neovide_scale_factor - 0.1<CR>')
  vim.keymap.set({ 'n', 'v' }, '<C-0>', ':lua vim.g.neovide_scale_factor = 1<CR>')
end

-- Load configuration modules
require('config.options').setup()
require('config.keymaps').setup()
require('config.autocmds').setup()

-- PackChanged hooks (MUST be defined before any vim.pack.add call)
-- These fire when plugins are installed or updated
vim.api.nvim_create_autocmd('PackChanged', {
  callback = function(ev)
    if ev.data.spec.name == 'nvim-treesitter' and ev.data.kind ~= 'delete' then
      if not ev.data.active then
        vim.cmd.packadd 'nvim-treesitter'
      end
      vim.cmd 'TSUpdate'
    end
  end,
})

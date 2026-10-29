-- Leader keys (must be set before plugins load)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Nerd Font support
vim.g.have_nerd_font = true

-- Enable bytecode cache for faster startup
vim.loader.enable()

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
    -- Download the prebuilt preview server binary
    if ev.data.spec.name == 'markdown-preview.nvim' and ev.data.kind ~= 'delete' then
      vim.system({ 'bash', ev.data.path .. '/app/install.sh' }):wait()
    end
  end,
})

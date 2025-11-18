-- Leader keys (must be set before plugins load)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Nerd Font support
vim.g.have_nerd_font = true

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
  -- vim.g.neovide_scroll_animation_length = 0.2
  -- vim.g.neovide_position_animation_length = 0.1
end

-- Load configuration modules
require('config.options').setup()
require('config.keymaps').setup()
require('config.autocmds').setup()

-- Lazy.nvim setup
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
  if vim.v.shell_error ~= 0 then
    error('Error cloning lazy.nvim:\n' .. out)
  end
end

vim.opt.rtp:prepend(lazypath)

require('lazy').setup(
  {
    -- tpope/vim-sleuth is a plugin that automatically detects the indentation style of the file.
    { 'tpope/vim-sleuth', event = 'VeryLazy' },

    -- Plugin for debugging Neovim Lua code
    {
      'folke/lazydev.nvim',
      ft = 'lua',
      opts = {
        library = {
          { path = 'luvit-meta/library', words = { 'vim%.uv' } },
        },
      },
    },

    -- luvit-meta is a plugin that provides a Lua library for Luvit, a Node.js-like runtime for Lua.
    { 'Bilal2453/luvit-meta', lazy = true },

    -- Conform.nvim for code formatting
    {
      'stevearc/conform.nvim',
      event = { 'BufWritePre' },
      cmd = { 'ConformInfo' },
      opts = {
        notify_on_error = false,
        format_on_save = function(bufnr)
          local disable_filetypes = { c = true, cpp = true, yaml = true, yml = true }
          local lsp_format_opt
          if disable_filetypes[vim.bo[bufnr].filetype] then
            lsp_format_opt = 'never'
          else
            lsp_format_opt = 'fallback'
          end
          return {
            timeout_ms = 500,
            lsp_format = lsp_format_opt,
          }
        end,
        formatters_by_ft = {
          lua = { 'stylua' },
          javascript = { 'prettierd', stop_after_first = true },
          typescript = { 'prettierd', stop_after_first = true },
          bash = { 'shfmt' },
          sh = { 'shfmt' },
        },
      },
    },

    -- Highlight todo, notes, etc in comments
    { 'folke/todo-comments.nvim', event = 'VimEnter', dependencies = { 'nvim-lua/plenary.nvim' }, opts = { signs = false } },

    -- Highlight, edit, and navigate code
    {
      'nvim-treesitter/nvim-treesitter',
      build = ':TSUpdate',
      main = 'nvim-treesitter.configs',
      opts = {
        ensure_installed = { 'bash', 'c', 'diff', 'go', 'html', 'lua', 'luadoc', 'markdown', 'markdown_inline', 'query', 'sql', 'vim', 'vimdoc' },
        auto_install = true,
        highlight = {
          enable = true,
        },
        indent = { enable = true, disable = { 'ruby' } },
        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = 'ti',
            node_incremental = 'tni',
            scope_incremental = 'tsi',
            node_decremental = 'tdd',
          },
        },
      },
    },

    -- Session management with auto-session
    {
      'rmagatti/auto-session',
      opts = {
        auto_restore = true,
        auto_save = true,
        auto_create = true,
        suppressed_dirs = { '~/', '~/Projects', '~/Downloads', '/' },
        session_lens = {
          load_on_setup = true,
          theme_conf = { border = true },
          previewer = false,
        },
        pre_save_cmds = { 'Neotree close' },
      },
    },

    -- Yank history plugin
    { 'gbprod/yanky.nvim', event = 'VeryLazy', opts = {} },

    -- TypeScript tools plugin
    {
      'pmizio/typescript-tools.nvim',
      event = 'VeryLazy',
      dependencies = { 'nvim-lua/plenary.nvim', 'neovim/nvim-lspconfig' },
      opts = {},
    },

    -- Scroll EOF plugin
    {
      'Aasim-A/scrollEOF.nvim',
      event = { 'CursorMoved', 'WinScrolled' },
      opts = {},
    },

    -- Render markdown.nvim - enhanced markdown rendering
    {
      'MeanderingProgrammer/render-markdown.nvim',
      dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' },
      ft = { 'markdown' },
      opts = {
        enabled = false,
      },
      keys = {
        {
          '<leader>cmt',
          '<cmd>RenderMarkdown toggle<cr>',
          desc = 'Toggle Render Markdown',
          ft = 'markdown',
        },
        {
          '<leader>cme',
          '<cmd>RenderMarkdown enable<cr>',
          desc = 'Enable Render Markdown',
          ft = 'markdown',
        },
        {
          '<leader>cmd',
          '<cmd>RenderMarkdown disable<cr>',
          desc = 'Disable Render Markdown',
          ft = 'markdown',
        },
      },
    },

    -- Add indentation guides even on blank lines
    {
      'lukas-reineke/indent-blankline.nvim',
      event = 'VeryLazy',
      main = 'ibl',
      opts = {},
    },

    -- Multiple cursors plugin
    {
      'mg979/vim-visual-multi',
      event = 'VeryLazy',
      branch = 'master',
    },

    -- Project-wide search and replace
    {
      'nvim-pack/nvim-spectre',
      build = false,
      cmd = 'Spectre',
      opts = { open_cmd = 'noswapfile vnew' },
      keys = {
        {
          '<leader>R',
          function()
            require('spectre').open()
          end,
          desc = 'Replace in files',
        },
      },
    },

    -- Plugin modules
    require 'plugins.snacks',
    require 'plugins.themes',
    require 'plugins.lint',
    require 'plugins.neo-tree',
    require 'plugins.cmp',
    require 'plugins.flash',
    require 'plugins.grapple',
    require 'plugins.lsp',
    require 'plugins.mini',
    require 'plugins.fzf',
    require 'plugins.which-key',
  },
  -- Use default Nerd Font icons
  { ui = { icons = {} } }
)

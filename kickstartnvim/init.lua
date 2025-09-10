-- Leader keys (must be set before plugins load)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Nerd Font support
vim.g.have_nerd_font = true

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
    'tpope/vim-sleuth',

    -- gitsigns is a plugin that shows git changes in the sign column.
    {
      'lewis6991/gitsigns.nvim',
      opts = {
        signs = {
          add = { text = '+' },
          change = { text = '~' },
          delete = { text = '_' },
          topdelete = { text = '‾' },
          changedelete = { text = '~' },
        },
      },
    },

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
    {
      'stevearc/conform.nvim',
      event = { 'BufWritePre' },
      cmd = { 'ConformInfo' },
      opts = {
        notify_on_error = false,
        format_on_save = function(bufnr)
          local disable_filetypes = { c = true, cpp = true }
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
        },
      },
    },

    -- tokyonight.nvim colorscheme
    {
      'folke/tokyonight.nvim',
      priority = 1000, -- Make sure to load this before all the other start plugins.
      opts = {
        transparent = true,
        styles = {
          sidebars = 'transparent',
          floats = 'transparent',
        },
      },
      init = function()
        -- Other styles: 'tokyonight-storm', 'tokyonight-moon', 'tokyonight-day'.
        vim.cmd.colorscheme 'tokyonight-night'
        vim.cmd.hi 'Comment gui=none'
      end,
    },

    -- Highlight todo, notes, etc in comments
    { 'folke/todo-comments.nvim', event = 'VimEnter', dependencies = { 'nvim-lua/plenary.nvim' }, opts = { signs = false } },

    -- Highlight, edit, and navigate code
    {
      'nvim-treesitter/nvim-treesitter',
      build = ':TSUpdate',
      main = 'nvim-treesitter.configs',
      opts = {
        ensure_installed = { 'bash', 'c', 'diff', 'go', 'html', 'lua', 'luadoc', 'markdown', 'markdown_inline', 'query', 'vim', 'vimdoc' },
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

    -- Flash motions
    {
      'folke/flash.nvim',
      event = 'VeryLazy',
      opts = { modes = { char = { enabled = false } } },
      keys = {
        {
          '<C-l>',
          mode = { 'n', 'x', 'o' },
          function()
            require('flash').jump()
          end,
          desc = 'Flash',
        },
        {
          '<C-S-l>',
          mode = { 'n', 'x', 'o' },
          function()
            require('flash').treesitter()
          end,
          desc = 'Flash Treesitter',
        },
        {
          'r',
          mode = 'o',
          function()
            require('flash').remote()
          end,
          desc = 'Remote Flash',
        },
        {
          'R',
          mode = { 'o', 'x' },
          function()
            require('flash').treesitter_search()
          end,
          desc = 'Treesitter Search',
        },
        {
          '<c-f>',
          mode = { 'c' },
          function()
            require('flash').toggle()
          end,
          desc = 'Toggle Flash Search',
        },
      },
    },

    -- Vim-surround for text object manipulation
    {
      'kylechui/nvim-surround',
      version = '*',
      event = 'VeryLazy',
      config = function()
        require('nvim-surround').setup {}
      end,
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
        post_restore_cmds = { 'Neotree filesystem reveal' },
      },
    },

    -- Mini.move for moving text
    {
      'echasnovski/mini.move',
      version = '*',
      config = function()
        require('mini.move').setup {
          mappings = {
            left = '<C-S-h>',
            right = '<C-S-l>',
            down = '<M-Down>',
            up = '<M-Up>',
            line_left = '<C-S-H>',
            line_right = '<C-S-L>',
            line_down = '<M-Down>',
            line_up = '<M-Up>',
          },
        }
      end,
    },

    -- Yank history plugin
    { 'gbprod/yanky.nvim', opts = {} },

    -- Code outline with Aerial
    {
      'stevearc/aerial.nvim',
      opts = {},
      dependencies = {
        'nvim-treesitter/nvim-treesitter',
        'nvim-tree/nvim-web-devicons',
      },
      config = function()
        require('aerial').setup {
          on_attach = function(bufnr)
            vim.keymap.set('n', '<C-k>', '<cmd>AerialPrev<CR>', { buffer = bufnr })
            vim.keymap.set('n', '<C-j>', '<cmd>AerialNext<CR>', { buffer = bufnr })
          end,
        }
      end,
    },

    -- TypeScript tools plugin
    {
      'pmizio/typescript-tools.nvim',
      dependencies = { 'nvim-lua/plenary.nvim', 'neovim/nvim-lspconfig' },
      opts = {},
    },

    -- Scroll EOF plugin
    {
      'Aasim-A/scrollEOF.nvim',
      event = { 'CursorMoved', 'WinScrolled' },
      opts = {},
    },

    -- Oil.nvim - file explorer that lets you edit your filesystem like a buffer
    {
      'stevearc/oil.nvim',
      opts = {},
      dependencies = { 'nvim-tree/nvim-web-devicons' },
      config = function()
        require('oil').setup {
          default_file_explorer = false,
          keymaps = {
            ['<C-h>'] = false,
            ['<C-l>'] = false,
          },
        }
        vim.keymap.set('n', '<leader>l', '<CMD>Oil<CR>', { desc = 'Open Oil file explorer' })
      end,
    },

    -- Render markdown.nvim - enhanced markdown rendering
    {
      'MeanderingProgrammer/render-markdown.nvim',
      dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' },
      ft = { 'markdown' },
      opts = {},
      keys = {
        {
          '<leader>mt',
          '<cmd>RenderMarkdown toggle<cr>',
          desc = 'Toggle Render Markdown',
          ft = 'markdown',
        },
        {
          '<leader>me',
          '<cmd>RenderMarkdown enable<cr>',
          desc = 'Enable Render Markdown',
          ft = 'markdown',
        },
        {
          '<leader>md',
          '<cmd>RenderMarkdown disable<cr>',
          desc = 'Disable Render Markdown',
          ft = 'markdown',
        },
      },
    },

    -- Plugin modules
    require 'plugins.debug',
    require 'plugins.indent_line',
    require 'plugins.lint',
    require 'plugins.autopairs',
    require 'plugins.neo-tree',
    require 'plugins.cmp',
    require 'plugins.copilot',
    require 'plugins.lsp',
    require 'plugins.mini',
    require 'plugins.multicursor',
    require 'plugins.telescope',
    require 'plugins.which-key',
  },
  -- Use default Nerd Font icons
  { ui = { icons = {} } }
)

-- Leader keys (must be set before plugins load)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Nerd Font support
vim.g.have_nerd_font = true

-- [[ Vim Options ]]
vim.opt.number = false
vim.opt.relativenumber = false
vim.opt.mouse = 'a'
vim.opt.showmode = false
vim.opt.breakindent = true
vim.opt.undofile = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = false
vim.opt.incsearch = true
vim.opt.signcolumn = 'yes'
vim.opt.updatetime = 250
vim.opt.timeoutlen = 300
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.list = true
vim.opt.listchars = { tab = '│ ', trail = '·', nbsp = '␣' }
vim.opt.inccommand = 'split'
vim.opt.cursorline = true
vim.opt.scrolloff = 17
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.expandtab = true
vim.opt.textwidth = 0
vim.opt.wrapmargin = 0
vim.opt.wrap = true
vim.opt.linebreak = true
vim.opt.winbar = '  📄  %f'
vim.opt.cmdheight = 1
vim.opt.swapfile = false
vim.opt.autowrite = true
vim.opt.autoread = true

-- Window appearance and borders
vim.opt.fillchars = {
  horiz = '━',
  horizup = '┻',
  horizdown = '┳',
  vert = '┃',
  vertleft = '┫',
  vertright = '┣',
  verthoriz = '╋',
}
vim.opt.laststatus = 3 -- Global statusline
vim.opt.winbar = '  📄  %f'

-- Sync clipboard after UI loads
vim.schedule(function()
  vim.opt.clipboard = 'unnamedplus'
end)

-- Window management (Ctrl+w equivalents)
vim.keymap.set('n', '<leader>wh', '<C-w>h', { desc = 'Move to left window' })
vim.keymap.set('n', '<leader>wl', '<C-w>l', { desc = 'Move to right window' })
vim.keymap.set('n', '<leader>wj', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<leader>wk', '<C-w><C-k>', { desc = 'Move focus to the upper window' })
vim.keymap.set('n', '<leader>ww', '<C-w>w', { desc = 'Switch to next window' })
vim.keymap.set('n', '<leader>wp', '<C-w>p', { desc = 'Switch to previous window' })
vim.keymap.set('n', '<leader>wv', '<C-w>v', { desc = 'Split window vertically' })
vim.keymap.set('n', '<leader>ws', '<C-w>s', { desc = 'Split window horizontally' })
vim.keymap.set('n', '<leader>wc', ':bd<CR>', { desc = 'Close current buffer' })
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
vim.keymap.set('n', '<leader>t', ':vert term<CR>', { noremap = true, silent = true, desc = '[O]pen a terminal in vsplit' })

-- Yanky keybindings
vim.keymap.set({ 'n', 'x' }, 'p', '<Plug>(YankyPutAfter)')
vim.keymap.set({ 'n', 'x' }, 'P', '<Plug>(YankyPutBefore)')
vim.keymap.set({ 'n', 'x' }, 'gp', '<Plug>(YankyGPutAfter)')
vim.keymap.set({ 'n', 'x' }, 'gP', '<Plug>(YankyGPutBefore)')
vim.keymap.set('n', '<c-p>', '<Plug>(YankyPreviousEntry)')
vim.keymap.set('n', '<c-n>', '<Plug>(YankyNextEntry)')

-- NeoTree
vim.keymap.set('n', '<leader>ee', '<Esc>:Neotree toggle<CR>', { noremap = true, desc = 'Open NeoTree files [E]xplor[E]r' })
vim.keymap.set('n', '<leader>eb', '<Esc>:Neotree toggle source=buffers<CR>', { noremap = true, desc = 'Open NeoTree [E]xplore [B]uffers' })

-- Custom mappings
vim.keymap.set('n', 'w', 'ciw', { desc = 'change word under cursor' })

-- Ensure Escape works to exit insert mode
vim.keymap.set('i', '<Esc>', '<Esc>', { noremap = true, silent = true })

-- Delete without yanking
vim.keymap.set({ 'n', 'v' }, 'd', '"_d', { desc = 'Delete without yanking' })
vim.keymap.set({ 'n', 'v' }, 'x', '"_x', { desc = 'Delete character without yanking' })
vim.keymap.set({ 'n', 'v' }, 'c', '"_c', { desc = 'Change without yanking' })

-- Better defaults
vim.keymap.set({ 'n', 'v' }, 'U', '<C-r>', { desc = 'Redo' })
vim.keymap.set({ 'n', 'v' }, 'gl', 'g_', { desc = 'Go to end of line' })
vim.keymap.set({ 'n', 'v' }, 'gh', '^', { desc = 'Go to beginning of line' })
vim.keymap.set({ 'n', 'v' }, 'ge', 'G', { desc = 'Go to end of file' })
vim.keymap.set('n', 'ga', 'ggVG', { desc = 'Select all' })

-- Visual mode enhancements
vim.keymap.set('v', 'V', 'j', { desc = 'Move down in visual mode' })
vim.keymap.set('v', 'v', 'k', { desc = 'Move up in visual mode' })
vim.keymap.set('n', '<leader>v', 'V', { desc = 'Enter visual line mode' })

-- macro recording and playback
vim.keymap.set('n', 'Q', '@q', { desc = 'Repeat q macro' })

-- Scroll navigation
vim.keymap.set('n', 'f', '<C-d>', { desc = 'Half page down' })
vim.keymap.set('n', 's', '<C-u>', { desc = 'Half page up' })

-- Line manipulation
vim.keymap.set('n', '<leader>o', 'o<Esc>k', { desc = 'Insert line below and stay' })
vim.keymap.set('n', '<leader>O', 'O<Esc>j', { desc = 'Insert line above and stay' })

-- System clipboard
vim.keymap.set('v', '<leader>y', '"+y', { desc = 'Yank to system clipboard' })
vim.keymap.set('n', '<leader>Y', '"+yg_', { desc = 'Yank line to system clipboard' })
vim.keymap.set('n', '<leader>y', '"+y', { desc = 'Yank to system clipboard' })
vim.keymap.set('n', '<leader>yy', '"+yy', { desc = 'Yank entire line to system clipboard' })
vim.keymap.set({ 'n', 'v' }, '<leader>p', '"+p', { desc = 'Paste from system clipboard' })
vim.keymap.set({ 'n', 'v' }, '<leader>P', '"+P', { desc = 'Paste before from system clipboard' })

-- LSP
vim.keymap.set('n', '<leader>,', vim.lsp.buf.hover, { desc = 'LSP Hover' })

-- Plugin-specific
vim.keymap.set('n', '<leader>cs', '<cmd>AerialNavToggle<CR>', { desc = '[C]ode [S]ymbols (Aerial)' })

-- Autocommands
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- Window border and distinction settings
vim.api.nvim_create_autocmd({ 'WinEnter', 'BufWinEnter' }, {
  desc = 'Highlight active window border',
  group = vim.api.nvim_create_augroup('window-distinction', { clear = true }),
  callback = function()
    vim.wo.winhighlight = 'Normal:Normal,NormalNC:NormalNC'
  end,
})

vim.api.nvim_create_autocmd('WinLeave', {
  desc = 'Dim inactive window',
  group = vim.api.nvim_create_augroup('window-distinction', { clear = false }),
  callback = function()
    vim.wo.winhighlight = 'Normal:NormalNC,NormalNC:NormalNC'
  end,
})

-- Set up window borders for floating windows
vim.api.nvim_create_autocmd('ColorScheme', {
  desc = 'Set window border colors',
  group = vim.api.nvim_create_augroup('window-borders', { clear = true }),
  callback = function()
    vim.api.nvim_set_hl(0, 'FloatBorder', { fg = '#00ff00', bg = 'NONE' })
    vim.api.nvim_set_hl(0, 'NormalFloat', { bg = '#1a1b26' })
    vim.api.nvim_set_hl(0, 'NormalNC', { bg = '#16161e' })
    vim.api.nvim_set_hl(0, 'WinSeparator', { fg = '#00ff00', bg = 'NONE' })
  end,
})

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
        ensure_installed = { 'bash', 'c', 'diff', 'html', 'lua', 'luadoc', 'markdown', 'markdown_inline', 'query', 'vim', 'vimdoc' },
        auto_install = true,
        highlight = {
          enable = true,
          additional_vim_regex_highlighting = { 'ruby' },
        },
        indent = { enable = true, disable = { 'ruby' } },
      },
      config = function()
        require('nvim-treesitter.configs').setup {
          incremental_selection = {
            enable = true,
            keymaps = {
              init_selection = 'ti',
              node_incremental = 'tni',
              scope_incremental = 'tsi',
              node_decremental = 'tdd',
            },
          },
        }
      end,
    },

    -- Flash motions
    {
      'folke/flash.nvim',
      event = 'VeryLazy',
      opts = { modes = { char = { enabled = false } } },
      keys = {
        {
          't',
          mode = { 'n', 'x', 'o' },
          function()
            require('flash').jump()
          end,
          desc = 'Flash',
        },
        {
          'T',
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

    -- Auto session management
    {
      'rmagatti/auto-session',
      lazy = false,
      opts = { suppressed_dirs = { '~/', '~/Projects', '~/Downloads', '/' } },
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
            vim.keymap.set('n', '{', '<cmd>AerialPrev<CR>', { buffer = bufnr })
            vim.keymap.set('n', '}', '<cmd>AerialNext<CR>', { buffer = bufnr })
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

    -- Plugin modules
    require 'plugins.debug',
    require 'plugins.indent_line',
    require 'plugins.lint',
    require 'plugins.autopairs',
    require 'plugins.neo-tree',
    require 'plugins.cmp',
    require 'plugins.codecompanion',
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

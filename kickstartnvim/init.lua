-- Personal Neovim configuration based on Kickstart.nvim

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

-- Sync clipboard after UI loads
vim.schedule(function()
  vim.opt.clipboard = 'unnamedplus'
end)

-- [[ Keymaps ]]
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')
vim.keymap.set('n', '<leader>cd', vim.diagnostic.setloclist, { desc = 'Open [D]iagnostic quickfix list' })
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- Window navigation
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<leader>wj', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<leader>wk', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- File operations
vim.api.nvim_set_keymap('n', '<C-s>', ':w<CR>', { noremap = true, silent = true, desc = 'Save the current file' })
vim.api.nvim_set_keymap('i', '<C-s>', '<Esc>:w<CR>', { noremap = true, silent = true, desc = 'Save the current file' })
vim.keymap.set('n', '<leader>o', ':vert term<CR>', { noremap = true, silent = true, desc = '[O]pen a terminal in vsplit' })

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

-- Delete without yanking
vim.keymap.set({'n', 'v'}, 'd', '"_d', { desc = 'Delete without yanking' })
vim.keymap.set({'n', 'v'}, 'x', '"_x', { desc = 'Delete character without yanking' })
vim.keymap.set({'n', 'v'}, 'c', '"_c', { desc = 'Change without yanking' })

-- Better defaults
vim.keymap.set({'n', 'v'}, 'U', '<C-r>', { desc = 'Redo' })
vim.keymap.set({'n', 'v'}, 'gl', 'g_', { desc = 'Go to end of line' })
vim.keymap.set({'n', 'v'}, 'gh', '^', { desc = 'Go to beginning of line' })
vim.keymap.set({'n', 'v'}, 'ge', 'G', { desc = 'Go to end of file' })
vim.keymap.set('n', 'ga', 'ggVG', { desc = 'Select all' })

-- Visual mode enhancements
vim.keymap.set('v', 'V', 'j', { desc = 'Move down in visual mode' })
vim.keymap.set('v', 'v', 'k', { desc = 'Move up in visual mode' })
vim.keymap.set('n', '<leader>v', 'V', { desc = 'Enter visual line mode' })

-- Macro and navigation
vim.keymap.set('n', 'Q', '@q', { desc = 'Repeat q macro' })
vim.keymap.set('n', '<C-j>', '<C-d>', { desc = 'Half page down' })
vim.keymap.set('i', '<C-j>', '<Esc><C-d>', { desc = 'Half page down (from insert)' })
vim.keymap.set('v', '<C-j>', '10j', { desc = 'Move 10 lines down' })
vim.keymap.set('n', '<C-k>', '<C-u>', { desc = 'Half page up' })
vim.keymap.set('i', '<C-k>', '<Esc><C-u>', { desc = 'Half page up (from insert)' })
vim.keymap.set('v', '<C-k>', '10k', { desc = 'Move 10 lines up' })

-- Line manipulation
vim.keymap.set('n', '<leader>j', 'o<Esc>k', { desc = 'Insert line below and stay' })
vim.keymap.set('n', '<leader>k', 'O<Esc>j', { desc = 'Insert line above and stay' })

-- System clipboard
vim.keymap.set('v', '<leader>y', '"+y', { desc = 'Yank to system clipboard' })
vim.keymap.set('n', '<leader>Y', '"+yg_', { desc = 'Yank line to system clipboard' })
vim.keymap.set('n', '<leader>y', '"+y', { desc = 'Yank to system clipboard' })
vim.keymap.set('n', '<leader>yy', '"+yy', { desc = 'Yank entire line to system clipboard' })
vim.keymap.set({'n', 'v'}, '<leader>p', '"+p', { desc = 'Paste from system clipboard' })
vim.keymap.set({'n', 'v'}, '<leader>P', '"+P', { desc = 'Paste before from system clipboard' })

-- LSP
vim.keymap.set('n', '<leader>,', vim.lsp.buf.hover, { desc = 'LSP Hover' })

-- Plugin-specific
vim.keymap.set('n', '<leader>cs', '<cmd>AerialNavToggle<CR>', { desc = '[C]ode [S]ymbols (Aerial)' })

-- [[ Autocommands ]]
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- [[ Lazy.nvim setup ]]
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
  if vim.v.shell_error ~= 0 then
    error('Error cloning lazy.nvim:\n' .. out)
  end
end
vim.opt.rtp:prepend(lazypath)
-- [[ Plugins ]]
require('lazy').setup({
  'tpope/vim-sleuth',

  -- Git integration
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

  -- Which-key for keybind hints
  {
    'folke/which-key.nvim',
    event = 'VimEnter',
    opts = {
      icons = {
        mappings = vim.g.have_nerd_font,
        keys = vim.g.have_nerd_font and {} or {
          Up = '<Up> ',
          Down = '<Down> ',
          Left = '<Left> ',
          Right = '<Right> ',
          C = '<C-…> ',
          M = '<M-…> ',
          D = '<D-…> ',
          S = '<S-…> ',
          CR = '<CR> ',
          Esc = '<Esc> ',
          ScrollWheelDown = '<ScrollWheelDown> ',
          ScrollWheelUp = '<ScrollWheelUp> ',
          NL = '<NL> ',
          BS = '<BS> ',
          Space = '<Space> ',
          Tab = '<Tab> ',
          F1 = '<F1>',
          F2 = '<F2>',
          F3 = '<F3>',
          F4 = '<F4>',
          F5 = '<F5>',
          F6 = '<F6>',
          F7 = '<F7>',
          F8 = '<F8>',
          F9 = '<F9>',
          F10 = '<F10>',
          F11 = '<F11>',
          F12 = '<F12>',
        },
      },
      spec = {
        { '<leader>c', group = '[C]ode', mode = { 'n', 'x' } },
        { '<leader>r', group = '[R]ename' },
        { '<leader>s', group = '[S]earch' },
        { '<leader>d', group = '[D]ebug' },
        { '<leader>e', group = 'N[E]otree' },
        { '<leader>w', group = '[W]indow' },
        { '<leader>a', group = '[A]I Assistant' },
      },
    },
  },

  {
    'nvim-telescope/telescope.nvim',
    event = 'VimEnter',
    branch = '0.1.x',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'debugloop/telescope-undo.nvim',
      {
        'nvim-telescope/telescope-fzf-native.nvim',
        build = 'make',
        cond = function()
          return vim.fn.executable 'make' == 1
        end,
      },
      { 'nvim-telescope/telescope-ui-select.nvim' },
      { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font },
    },
    config = function()
      local actions = require 'telescope.actions'
      require('telescope').setup {
        defaults = {
          mappings = {
            i = {
              ['<S-Tab>'] = actions.move_selection_next,
              ['<Tab>'] = actions.move_selection_previous,
            },
            n = {
              ['<S-Tab>'] = actions.move_selection_next,
              ['<Tab>'] = actions.move_selection_previous,
            },
          },
        },
        extensions = {
          undo = {},
          ['ui-select'] = {
            require('telescope.themes').get_dropdown(),
          },
        },
      }

      pcall(require('telescope').load_extension, 'fzf')
      pcall(require('telescope').load_extension, 'ui-select')
      pcall(require('telescope').load_extension, 'undo')

      local builtin = require 'telescope.builtin'
      vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
      vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
      vim.keymap.set('n', '<leader>sm', builtin.marks, { desc = '[S]earch [M]arks' })
      vim.keymap.set('n', '<leader>sp', builtin.builtin, { desc = '[S]earch select Telesco[P]e' })
      vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
      vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = '[S]earch [R]esume' })
      vim.keymap.set('n', '<leader>s.', builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
      vim.keymap.set('n', '<leader>sc', builtin.command_history, { desc = '[S] Find existing [C]ommands' })
      vim.keymap.set('n', '<leader>st', builtin.colorscheme, { desc = '[S]earch [T]hemes' })
      vim.keymap.set('n', '<leader>sj', builtin.jumplist, { desc = '[S] Find [J]umplist' })
      vim.keymap.set('n', 'U', '<cmd>Telescope undo<cr>', { desc = 'Find [U]ndo' })
      vim.keymap.set('n', '<leader>f', builtin.find_files, { desc = '[S]earch [F]iles' })
      vim.keymap.set('n', '<leader>b', function()
        builtin.buffers { path_display = { 'truncate' }, sort_lastused = true }
      end, { desc = 'Find existing buffers' })
      vim.keymap.set('n', '<leader>/', builtin.current_buffer_fuzzy_find, { desc = 'Grep Buffer' })
      vim.keymap.set('n', '<leader>?', builtin.live_grep, { desc = 'Grep Repo' })
      vim.keymap.set('n', '<leader>*', builtin.grep_string, { desc = 'Search current word' })
      vim.keymap.set('n', '<leader>sn', function()
        builtin.find_files { cwd = vim.fn.stdpath 'config' }
      end, { desc = '[S]earch [N]eovim files' })
    end,
  },
  {
    'folke/lazydev.nvim',
    ft = 'lua',
    opts = {
      library = {
        { path = 'luvit-meta/library', words = { 'vim%.uv' } },
      },
    },
  },
  { 'Bilal2453/luvit-meta', lazy = true },
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      { 'williamboman/mason.nvim', config = true },
      'williamboman/mason-lspconfig.nvim',
      'WhoIsSethDaniel/mason-tool-installer.nvim',
      { 'j-hui/fidget.nvim', opts = {} },
      'hrsh7th/cmp-nvim-lsp',
    },
    config = function()
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
        callback = function(event)
          local map = function(keys, func, desc, mode)
            mode = mode or 'n'
            vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
          end

          map('gd', function()
            require('telescope.builtin').lsp_definitions { show_line = false }
          end, '[G]oto [D]efinition')

          map('gr', function()
            require('telescope.builtin').lsp_references { show_line = false }
          end, '[G]oto [R]eferences')

          map('gi', function()
            require('telescope.builtin').lsp_implementations { show_line = false }
          end, '[G]oto [I]mplementation')

          map('gD', function()
            require('telescope.builtin').lsp_type_definitions { show_line = false }
          end, '[G]oto Type [D]efinition')

          map('<leader>ss', function()
            require('telescope.builtin').lsp_document_symbols { show_line = false }
          end, '[S]earch document [s]ymbols')

          map('<leader>sS', function()
            require('telescope.builtin').lsp_dynamic_workspace_symbols { show_line = false }
          end, '[S]earch workspace [S]ymbols')

          map('<leader>cr', vim.lsp.buf.rename, 'Code [R]ename')
          map('<leader>ca', vim.lsp.buf.code_action, 'Code [A]ction', { 'n', 'x' })
          map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
            local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
            vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.document_highlight,
            })

            vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.clear_references,
            })

            vim.api.nvim_create_autocmd('LspDetach', {
              group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
              callback = function(event2)
                vim.lsp.buf.clear_references()
                vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
              end,
            })
          end

          if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
            map('<leader>th', function()
              vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
            end, '[T]oggle Inlay [H]ints')
          end
        end,
      })

      -- Change diagnostic symbols in the sign column (gutter)
      local signs = { Error = '', Warn = '', Hint = '', Info = '' }
      for type, icon in pairs(signs) do
        local hl = 'DiagnosticSign' .. type
        vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
      end

      -- LSP servers and clients are able to communicate to each other what features they support.
      -- Extend LSP capabilities with nvim-cmp for better completion support.
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())

      -- Enable the following language servers
      -- Add/remove LSPs below. See :help lspconfig-all for available servers. Override settings as needed.
      local servers = {
        -- clangd = {},
        gopls = {},
        pyright = {},
        -- rust_analyzer = {},
        -- ... See :help lspconfig-all for more servers. For TypeScript, consider typescript-tools.nvim or ts_ls.

        lua_ls = {
          -- cmd = {...},
          -- filetypes = { ...},
          -- capabilities = {},
          settings = {
            Lua = {
              completion = {
                callSnippet = 'Replace',
              },
            },
          },
        },
      }

      require('mason').setup()

      local ensure_installed = vim.tbl_keys(servers or {})
      vim.list_extend(ensure_installed, {
        'stylua',
      })
      require('mason-tool-installer').setup { ensure_installed = ensure_installed }

      require('mason-lspconfig').setup {
        handlers = {
          function(server_name)
            local server = servers[server_name] or {}
            server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
            require('lspconfig')[server_name].setup(server)
          end,
        },
      }
    end,
  },

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

  {
    'hrsh7th/nvim-cmp',
    event = 'InsertEnter',
    dependencies = {
      {
        'L3MON4D3/LuaSnip',
        build = (function()
          if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then
            return
          end
          return 'make install_jsregexp'
        end)(),
        dependencies = {
          -- Optionally add 'rafamadriz/friendly-snippets' for more snippet support.
        },
      },
      'saadparwaiz1/cmp_luasnip',

      -- Adds other completion capabilities.
      --  nvim-cmp does not ship with all sources by default. They are split
      --  into multiple repos for maintenance purposes.
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-path',
    },
    config = function()
      -- See `:help cmp`
      local cmp = require 'cmp'
      local luasnip = require 'luasnip'
      luasnip.config.setup {}

      local has_words_before = function()
        unpack = unpack or table.unpack
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match '%s' == nil
      end

      cmp.setup {
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        completion = { completeopt = 'menu,menuone,noinsert,noselect' },
        -- See :help ins-completion for details on completion mappings.
        mapping = cmp.mapping.preset.insert {
          -- Select the [n]ext item
          ['<C-n>'] = cmp.mapping.select_next_item(),
          -- Select the [p]revious item
          ['<C-p>'] = cmp.mapping.select_prev_item(),

          -- Scroll the documentation window [b]ack / [f]orward
          ['<C-b>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          -- ...existing code...

          ['<C-Space>'] = cmp.mapping.confirm {
            behavior = cmp.ConfirmBehavior.Insert,
            select = true,
          },

          ['<Tab>'] = function(fallback)
            if not cmp.select_next_item() then
              if vim.bo.buftype ~= 'prompt' and has_words_before() then
                cmp.complete()
              else
                fallback()
              end
            end
          end,

          ['<S-Tab>'] = function(fallback)
            if not cmp.select_prev_item() then
              if vim.bo.buftype ~= 'prompt' and has_words_before() then
                cmp.complete()
              else
                fallback()
              end
            end
          end,

          -- Think of <c-l> as moving to the right of your snippet expansion.
          -- <C-l> and <C-h> navigate snippet placeholders forward/backward.
          ['<C-l>'] = cmp.mapping(function()
            if luasnip.expand_or_locally_jumpable() then
              luasnip.expand_or_jump()
            end
          end, { 'i', 's' }),
          ['<C-h>'] = cmp.mapping(function()
            if luasnip.locally_jumpable(-1) then
              luasnip.jump(-1)
            end
          end, { 'i', 's' }),

          -- For more advanced Luasnip keymaps (e.g. selecting choice nodes, expansion) see:
          -- See LuaSnip docs for advanced keymaps.
        },
        sources = {
          {
            name = 'lazydev',
            -- group_index = 0 skips LuaLS completions as recommended by lazydev
            group_index = 0,
          },
          { name = 'nvim_lsp' },
          { name = 'luasnip' },
          { name = 'path' },
        },
      }
    end,
  },

  {
    -- Colorscheme plugin. Use :Telescope colorscheme to preview installed themes.
    'folke/tokyonight.nvim',
    priority = 1000, -- Make sure to load this before all the other start plugins.
    init = function()
      -- Load the colorscheme here.
      -- Other styles: 'tokyonight-storm', 'tokyonight-moon', 'tokyonight-day'.
      vim.cmd.colorscheme 'tokyonight-night'

      -- You can configure highlights by doing something like:
      vim.cmd.hi 'Comment gui=none'
    end,
  },

  -- Highlight todo, notes, etc in comments
  { 'folke/todo-comments.nvim', event = 'VimEnter', dependencies = { 'nvim-lua/plenary.nvim' }, opts = { signs = false } },

  -- CodeCompanion - AI coding assistant
  {
    "olimorris/codecompanion.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "hrsh7th/nvim-cmp", -- Optional: For using slash commands and variables in the chat buffer
      "nvim-telescope/telescope.nvim", -- Optional: For using slash commands
      { "stevearc/dressing.nvim", opts = {} }, -- Optional: Improves `vim.ui.select`
    },
    config = function()
      require("codecompanion").setup({
        strategies = {
          chat = {
            adapter = "anthropic",
          },
          inline = {
            adapter = "anthropic",
          },
          agent = {
            adapter = "anthropic",
          },
        },
        adapters = {
          anthropic = function()
            return require("codecompanion.adapters").extend("anthropic", {
              env = {
                api_key = "ANTHROPIC_AUTH_TOKEN",
                url = "ANTHROPIC_BASE_URL",
              },
            })
          end,
        },
      })
    end,
    keys = {
      { "<leader>ai", "<cmd>CodeCompanionActions<cr>", desc = "[A][I] CodeCompanion Actions", mode = { "n", "v" } },
      { "<leader>ac", "<cmd>CodeCompanionChat Toggle<cr>", desc = "[A]I [C]hat Toggle", mode = { "n", "v" } },
      { "<leader>aa", "<cmd>CodeCompanionAdd<cr>", desc = "[A]I [A]dd to Chat", mode = "v" },
      { "<leader>ae", "<cmd>CodeCompanionExplain<cr>", desc = "[A]I [E]xplain Code", mode = "v" },
      { "<leader>ar", "<cmd>CodeCompanionReview<cr>", desc = "[A]I [R]eview Code", mode = "v" },
      { "<leader>at", "<cmd>CodeCompanionTest<cr>", desc = "[A]I Generate [T]ests", mode = "v" },
      { "<leader>af", "<cmd>CodeCompanionFix<cr>", desc = "[A]I [F]ix Code", mode = "v" },
      { "<leader>ao", "<cmd>CodeCompanionOptimize<cr>", desc = "[A]I [O]ptimize Code", mode = "v" },
    },
  },

  { -- Collection of various small independent plugins/modules
    'echasnovski/mini.nvim',
    config = function()
      -- Enhanced textobjects: e.g. va) selects around paren, yinq yanks inside next quote, ci' changes inside quote.
      require('mini.ai').setup { n_lines = 500 }

      -- Surround mappings: saiw) add, sd' delete, sr)' replace, etc.
      require('mini.surround').setup {
        mappings = {
          add = '<leader>ra', -- Add surrounding in Normal and Visual modes
          delete = '<leader>rd', -- Delete surrounding
          find = '<leader>rf', -- Find surrounding (to the right)
          find_left = '<leader>rF', -- Find surrounding (to the left)
          highlight = '<leader>rh', -- Highlight surrounding
          replace = '<leader>rr', -- Replace surrounding
          update_n_lines = '<leader>rg', -- Update `n_lines`
        },
      }

      -- Simple and easy statusline.
      local statusline = require 'mini.statusline'
      statusline.setup {
        content = {
          active = function()
            local mode, mode_hl = MiniStatusline.section_mode { trunc_width = 120 }
            local git = MiniStatusline.section_git { trunc_width = 100 }
            local diagnostics = MiniStatusline.section_diagnostics { trunc_width = 75 }
            local location = MiniStatusline.section_location { trunc_width = 75 }
            local search = MiniStatusline.section_searchcount { trunc_width = 75 }
            return MiniStatusline.combine_groups {
              { hl = mode_hl, strings = { mode } },
              { hl = 'MiniStatuslineDevinfo', strings = { git, diagnostics } },
              '%<', -- Mark general truncate point
              '%=', -- End left alignment
              { hl = mode_hl, strings = { search, location } },
            }
          end,
          inactive = nil,
        },

        use_icons = vim.g.have_nerd_font,
      }

      ---@diagnostic disable-next-line: duplicate-set-field
      statusline.section_location = function()
        return '%2l:%-2v'
      end

    end,
  },
  { -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    main = 'nvim-treesitter.configs', -- Sets main module to use for opts
    -- [[ Configure Treesitter ]] See `:help nvim-treesitter`
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
    -- See nvim-treesitter docs for more modules and features.
  },

  -- Kickstart plugin modules
  require 'kickstart.plugins.debug',
  require 'kickstart.plugins.indent_line',
  require 'kickstart.plugins.lint',
  require 'kickstart.plugins.autopairs',
  require 'kickstart.plugins.neo-tree',

  -- Additional plugins from custom/plugins
  -- Flash motions
  {
    'folke/flash.nvim',
    event = 'VeryLazy',
    opts = {},
    keys = {
      { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
      { "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
      { "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
      { "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
      { "<c-f>", mode = { "c" }, function() require("flash").toggle() end, desc = "Toggle Flash Search" },
    },
  },

  -- Auto session management
  {
    'rmagatti/auto-session',
    lazy = false,
    opts = {
      suppressed_dirs = { '~/', '~/Projects', '~/Downloads', '/' },
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
          down = '<C-S-j>',
          up = '<C-S-k>',
          line_left = '<C-S-H>',
          line_right = '<C-S-L>',
          line_down = '<C-S-J>',
          line_up = '<C-S-K>',
        },
      }
    end,
  },

  -- Yank history plugin
  {
    'gbprod/yanky.nvim',
    opts = {},
  },

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

  -- Monokai Pro colorscheme
  {
    'loctvl842/monokai-pro.nvim',
    config = function()
      require('monokai-pro').setup {
        filter = 'spectrum',
      }
      vim.cmd [[colorscheme monokai-pro]]
    end,
  },

  -- Scroll EOF plugin
  {
    'Aasim-A/scrollEOF.nvim',
    event = { 'CursorMoved', 'WinScrolled' },
    opts = {},
  },

  -- To modularize config, add files in `lua/custom/plugins/*.lua` and uncomment below:
  -- { import = 'custom.plugins' },
}, {
  ui = {
    -- If you are using a Nerd Font: set icons to an empty table which will use the
    -- default lazy.nvim defined Nerd Font icons, otherwise define a unicode icons table
    icons = vim.g.have_nerd_font and {} or {
      cmd = '⌘',
      config = '🛠',
      event = '📅',
      ft = '📂',
      init = '⚙',
      keys = '🗝',
      plugin = '🔌',
      runtime = '💻',
      require = '🌙',
      source = '📄',
      start = '🚀',
      task = '📌',
      lazy = '💤 ',
    },
  },
})

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et

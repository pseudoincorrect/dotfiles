-- Telescope fuzzy finder
return {
  'nvim-telescope/telescope.nvim',
  event = 'VimEnter',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'debugloop/telescope-undo.nvim',
    'nvim-telescope/telescope-live-grep-args.nvim',
    'nvim-telescope/telescope-frecency.nvim',
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
            ['<Esc>'] = actions.close,
          },
          n = {
            ['<S-Tab>'] = actions.move_selection_next,
            ['<Tab>'] = actions.move_selection_previous,
          },
        },
      },
      pickers = {
        marks = {
          attach_mappings = function(prompt_bufnr, map)
            map({ 'i', 'n' }, '<C-k>', function()
              actions.delete_mark(prompt_bufnr)
            end)
            return true
          end,
        },
        lsp_document_symbols = {
          symbol_width = 50,
          show_line = true,
          fname_width = 30,
        },
      },
      extensions = {
        undo = {},
        ['ui-select'] = {
          require('telescope.themes').get_dropdown(),
        },
        live_grep_args = {
          auto_quoting = true, -- enable/disable auto-quoting
          mappings = {
            i = {
              ['<C-k>'] = require('telescope-live-grep-args.actions').quote_prompt(),
              ['<C-i>'] = require('telescope-live-grep-args.actions').quote_prompt { postfix = ' --iglob ' },
            },
          },
        },
        frecency = {
          show_scores = false,
          show_unindexed = true,
          ignore_patterns = { '*.git/*', '*/tmp/*' },
          disable_devicons = false,
        },
      },
    }

    pcall(require('telescope').load_extension, 'fzf')
    pcall(require('telescope').load_extension, 'ui-select')
    pcall(require('telescope').load_extension, 'undo')
    pcall(require('telescope').load_extension, 'live_grep_args')
    pcall(require('telescope').load_extension, 'frecency')

    local builtin = require 'telescope.builtin'
    vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = 'Help' })
    vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = 'Keymaps' })
    vim.keymap.set('n', '<leader>sm', builtin.marks, { desc = 'Marks' })
    vim.keymap.set('n', '<leader>sp', builtin.builtin, { desc = 'Telescopes' })
    vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = 'Diagnostics' })
    vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = 'Resume' })
    vim.keymap.set('n', '<leader>so', builtin.oldfiles, { desc = 'Old Files' })
    vim.keymap.set('n', '<leader>sc', builtin.command_history, { desc = 'Commands' })
    vim.keymap.set('n', '<leader>st', builtin.colorscheme, { desc = 'Themes' })
    vim.keymap.set('n', '<leader>sj', builtin.jumplist, { desc = 'Jumplist' })
    vim.keymap.set('n', '<leader>su', '<cmd>Telescope undo<cr>', { desc = 'Undos' })
    vim.keymap.set('n', '<leader>s*', builtin.grep_string, { desc = 'Current word' })
    vim.keymap.set('v', '<leader>sv', builtin.grep_string, { desc = 'Grep Repo Selection' })
    vim.keymap.set('n', '<leader>sx', builtin.diagnostics, { desc = 'Problems' })
    vim.keymap.set('n', '<leader>f', function()
      builtin.find_files {
        path_display = { 'truncate' },
      }
    end, { desc = 'Files' })
    vim.keymap.set('n', '<leader>/', builtin.current_buffer_fuzzy_find, { desc = 'Grep Buffer' })

    vim.keymap.set('n', '<leader>b', function()
      builtin.buffers {
        path_display = { 'truncate' },
        sort_lastused = true,
        attach_mappings = function(prompt_bufnr, map)
          map('i', '<C-k>', actions.delete_buffer)
          return true
        end,
      }
    end, { desc = 'Buffers' })

    vim.keymap.set('n', '<leader>sg', function()
      require('telescope').extensions.live_grep_args.live_grep_args()
    end, { desc = 'Grep Repo' })

    vim.keymap.set('n', '<leader>sn', function()
      builtin.find_files { cwd = vim.fn.stdpath 'config' }
    end, { desc = 'Neovim files' })

    vim.keymap.set('n', '<leader>sf', function()
      require('telescope').extensions.frecency.frecency()
    end, { desc = 'Frecency' })
  end,
}

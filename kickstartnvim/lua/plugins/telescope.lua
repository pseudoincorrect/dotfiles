-- Telescope fuzzy finder
return {
  'nvim-telescope/telescope.nvim',
  event = 'VimEnter',
  branch = '0.1.x',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'debugloop/telescope-undo.nvim',
    'nvim-telescope/telescope-live-grep-args.nvim',
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
        live_grep_args = {
          auto_quoting = true, -- enable/disable auto-quoting
          mappings = {
            i = {
              ['<C-k>'] = require('telescope-live-grep-args.actions').quote_prompt(),
              ['<C-i>'] = require('telescope-live-grep-args.actions').quote_prompt({ postfix = ' --iglob ' }),
            },
          },
        },
      },
    }

    pcall(require('telescope').load_extension, 'fzf')
    pcall(require('telescope').load_extension, 'ui-select')
    pcall(require('telescope').load_extension, 'undo')
    pcall(require('telescope').load_extension, 'live_grep_args')

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
    vim.keymap.set('n', '<leader>f', builtin.find_files, { desc = 'Search [F]iles' })
    vim.keymap.set('n', '<leader>b', function()
      builtin.buffers { path_display = { 'truncate' }, sort_lastused = true }
    end, { desc = 'Search [B]uffers' })
    vim.keymap.set('n', '<leader>/', builtin.current_buffer_fuzzy_find, { desc = 'Grep Buffer' })
    vim.keymap.set('n', '<leader>?', function()
      require('telescope').extensions.live_grep_args.live_grep_args()
    end, { desc = 'Grep Repo (with args)' })
    vim.keymap.set('n', '<leader>*', builtin.grep_string, { desc = 'Search current word' })
    vim.keymap.set('n', '<leader>sn', function()
      builtin.find_files { cwd = vim.fn.stdpath 'config' }
    end, { desc = '[S]earch [N]eovim files' })
  end,
}

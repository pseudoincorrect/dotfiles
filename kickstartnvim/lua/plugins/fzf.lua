return {
  'ibhagwan/fzf-lua',
  event = 'VimEnter',
  dependencies = {
    'nvim-tree/nvim-web-devicons',
  },
  config = function()
    local fzf = require 'fzf-lua'
    local actions = require 'fzf-lua.actions'

    fzf.setup {
      winopts = {
        height = 0.85,
        width = 0.80,
        preview = {
          default = 'bat',
          border = 'border',
          wrap = 'nowrap',
          hidden = 'nohidden',
          vertical = 'down:45%',
          horizontal = 'right:50%',
          layout = 'flex',
          flip_columns = 120,
        },
      },
      keymap = {
        builtin = {
          ['<C-/>'] = 'toggle-help',
          ['<C-d>'] = 'preview-page-down',
          ['<C-u>'] = 'preview-page-up',
        },
        fzf = {
          ['tab'] = 'up',
          ['shift-tab'] = 'down',
          ['ctrl-z'] = 'abort',
          ['ctrl-a'] = 'beginning-of-line',
          ['ctrl-e'] = 'end-of-line',
          ['alt-a'] = 'toggle-all',
          ['ctrl-q'] = 'select-all+accept',
        },
      },
      actions = {
        files = {
          ['default'] = actions.file_edit_or_qf,
          ['ctrl-s'] = actions.file_split,
          ['ctrl-v'] = actions.file_vsplit,
          ['ctrl-t'] = actions.file_tabedit,
          ['ctrl-k'] = actions.file_sel_to_qf,
        },
        buffers = {
          ['default'] = actions.buf_edit,
          ['ctrl-s'] = actions.buf_split,
          ['ctrl-v'] = actions.buf_vsplit,
          ['ctrl-t'] = actions.buf_tabedit,
          ['ctrl-k'] = actions.buf_del,
        },
      },
      files = {
        prompt = 'Files❯ ',
        multiprocess = true,
        file_icons = true,
        color_icons = true,
        git_icons = true,
        find_opts = [[-type f -not -path '*/\.git/*' -printf '%P\n']],
        fd_opts = [[--color=never --type f --hidden --follow --exclude .git]],
        formatter = 'path.filename_first',
      },
      grep = {
        prompt = 'Rg❯ ',
        input_prompt = 'Grep For❯ ',
        multiprocess = true,
        file_icons = true,
        color_icons = true,
        git_icons = true,
        rg_opts = '--column --line-number --no-heading --color=always --smart-case --max-columns=4096 -e',
      },
      buffers = {
        prompt = 'Buffers❯ ',
        file_icons = true,
        color_icons = true,
        sort_lastused = true,
        formatter = 'path.filename_first',
      },
      oldfiles = {
        prompt = 'History❯ ',
        cwd_only = false,
        include_current_session = true,
      },
      lsp = {
        symbols = {
          prompt = 'Symbols❯ ',
          symbol_style = 1,
          symbol_icons = {
            File = '',
            Module = '',
            Namespace = '',
            Package = '',
            Class = '',
            Method = '',
            Property = '',
            Field = '',
            Constructor = '',
            Enum = '',
            Interface = '',
            Function = '',
            Variable = '',
            Constant = '',
            String = '',
            Number = '',
            Boolean = '',
            Array = '',
            Object = '',
            Key = '',
            Null = '',
            EnumMember = '',
            Struct = '',
            Event = '',
            Operator = '',
            TypeParameter = '',
          },
        },
      },
    }

    vim.keymap.set('n', '<leader>sh', fzf.help_tags, { desc = 'Help' })
    vim.keymap.set('n', '<leader>sk', fzf.keymaps, { desc = 'Keymaps' })
    vim.keymap.set('n', '<leader>sm', fzf.marks, { desc = 'Marks' })
    vim.keymap.set('n', '<leader>sp', fzf.builtin, { desc = 'Pickers' })
    vim.keymap.set('n', '<leader>sd', fzf.diagnostics_document, { desc = 'Diagnostics' })
    vim.keymap.set('n', '<leader>sr', fzf.resume, { desc = 'Resume' })
    vim.keymap.set('n', '<leader>so', fzf.oldfiles, { desc = 'Old Files' })
    vim.keymap.set('n', '<leader>sc', fzf.command_history, { desc = 'Commands' })
    vim.keymap.set('n', '<leader>st', fzf.colorschemes, { desc = 'Themes' })
    vim.keymap.set('n', '<leader>sj', fzf.jumps, { desc = 'Jumplist' })
    vim.keymap.set('n', '<leader>su', fzf.changes, { desc = 'Undos' })
    vim.keymap.set('n', '<leader>s*', fzf.grep_cword, { desc = 'Current word' })
    vim.keymap.set('v', '<leader>sv', fzf.grep_visual, { desc = 'Grep Repo Selection' })
    vim.keymap.set('n', '<leader>sx', fzf.diagnostics_document, { desc = 'Problems' })
    vim.keymap.set('n', '<leader>f', fzf.files, { desc = 'Files' })
    vim.keymap.set('n', '<leader>/', fzf.lgrep_curbuf, { desc = 'Grep Buffer' })
    vim.keymap.set('n', '<leader>b', fzf.buffers, { desc = 'Buffers' })
    vim.keymap.set('n', '<leader>sg', fzf.live_grep, { desc = 'Grep Repo' })
    vim.keymap.set('n', '<leader>sn', function()
      fzf.files { cwd = vim.fn.stdpath 'config' }
    end, { desc = 'Neovim files' })
    vim.keymap.set('n', '<leader>F', function()
      fzf.files {
        fd_opts = [[--color=never --type f --hidden --follow --no-ignore]],
      }
    end, { desc = 'Files (all)' })
  end,
}

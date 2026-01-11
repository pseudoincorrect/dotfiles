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
        width = 0.90,
        preview = {
          default = 'bat',
          border = 'border',
          wrap = 'nowrap',
          hidden = 'nohidden',
          vertical = 'down:45%',
          horizontal = 'left:40%',
          layout = 'flex',
          flip_columns = 120,
        },
      },
      keymap = {
        builtin = {
          ['<C-/>'] = 'toggle-help',
          ['<S-Down>'] = 'preview-down',
          ['<S-Up>'] = 'preview-up',
        },
        fzf = {
          ['tab'] = 'up',
          ['shift-tab'] = 'down',
          ['ctrl-z'] = 'abort',
          ['ctrl-a'] = 'beginning-of-line',
          ['ctrl-e'] = 'end-of-line',
          ['alt-a'] = 'toggle-all',
          ['ctrl-q'] = 'select-all+accept',
          ['shift-down'] = 'preview-down',
          ['shift-up'] = 'preview-up',
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
        git_icons = false,
        find_opts = [[-type f -not -path '*/\.git/*' -printf '%P\n']],
        fd_opts = [[--color=never --type f --hidden --follow --exclude .git]],
        formatter = 'path.filename_first',
        fzf_opts = { ['--scheme'] = 'path' },
      },
      grep = {
        prompt = 'Rg❯ ',
        input_prompt = 'Grep For❯ ',
        multiprocess = true,
        file_icons = true,
        color_icons = true,
        git_icons = false,
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
    vim.keymap.set('n', '<leader>sT', fzf.colorschemes, { desc = 'Themes' })
    vim.keymap.set('n', '<leader>sj', fzf.jumps, { desc = 'Jumplist' })
    vim.keymap.set('n', '<leader>su', fzf.changes, { desc = 'Undos' })
    vim.keymap.set('n', '<leader>s*', fzf.grep_cword, { desc = 'Current word' })
    vim.keymap.set('n', '<leader>sv', fzf.git_status, { desc = 'Changed git files' })
    vim.keymap.set('v', '<leader>sv', fzf.grep_visual, { desc = 'Grep Repo with Selection' })
    vim.keymap.set('n', '<leader>sx', fzf.diagnostics_document, { desc = 'Problems' })
    vim.keymap.set('n', '<leader>f', fzf.files, { desc = 'Files' })
    vim.keymap.set({ 'n', 'i', 'v', 't' }, '<C-f>', fzf.files, { desc = 'Files' })
    vim.keymap.set('n', '<leader>/', fzf.lgrep_curbuf, { desc = 'Grep Buffer' })
    vim.keymap.set('n', '<leader>b', fzf.buffers, { desc = 'Buffers' })
    vim.keymap.set({ 'n', 'i', 'v', 't' }, '<C-b>', fzf.buffers, { desc = 'Buffers' })
    vim.keymap.set('n', '<leader>s/', fzf.live_grep, { desc = 'Live Grep' })
    vim.keymap.set('n', '<leader>sf', fzf.grep_project, { desc = 'Live Fuzzy' })

    -- Open terminal buffers
    local terminals = function()
      -- Exit insert/terminal mode before opening fzf to prevent character leakage
      vim.cmd 'stopinsert'
      -- Defer execution to ensure mode transition completes
      vim.schedule(function()
        fzf.buffers {
          fzf_opts = { ['--query'] = 'term://' },
        }
      end)
    end
    vim.keymap.set('n', '<leader>st', terminals, { desc = 'Terminals' })
    vim.keymap.set({ 'n', 'i', 'v', 't' }, '<C-t>', terminals, { desc = 'Terminals' })

    -- Zoxide integration
    vim.keymap.set('n', '<leader>sz', function()
      fzf.fzf_exec('zoxide query -l', {
        prompt = 'Zoxide❯ ',
        actions = {
          ['default'] = function(selected)
            if selected and selected[1] then
              vim.cmd('cd ' .. selected[1])
            end
          end,
        },
      })
    end, { desc = 'Zoxide' })

    -- Find Neovim config files
    vim.keymap.set('n', '<leader>sn', function()
      fzf.files { cwd = vim.fn.stdpath 'config' }
    end, { desc = 'Neovim files' })

    -- Find all files
    vim.keymap.set('n', '<leader>F', function()
      fzf.files {
        fd_opts = [[--color=never --type f --hidden --follow --no-ignore]],
      }
    end, { desc = 'Files (all)' })

    -- Go Packages
    vim.keymap.set('n', '<leader>sg', function()
      fzf.fzf_exec('go list all', {
        prompt = 'Go Packages❯ ',
        actions = {
          ['default'] = function(selected)
            if selected and selected[1] then
              vim.api.nvim_put({ selected[1] }, '', true, true)
            end
          end,
        },
      })
    end, { desc = 'Go Packages' })

    -- Spelling Suggestions
    vim.keymap.set('n', '<leader>cs', fzf.spell_suggest, { desc = 'Spelling Suggestions' })
  end,
}

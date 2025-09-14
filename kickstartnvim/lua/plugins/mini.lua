-- Collection of various small independent plugins/modules
return {
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

    -- Mini.files configuration
    local mini_files = require 'mini.files'

    mini_files.setup {
      mappings = {
        close = '<Esc>',
        -- go_in = 'l',
        go_in_plus = 'l',
        go_out = 'h',
        go_out_plus = 'H',
        reset = '.',
        reveal_cwd = 'r',
        show_help = '?',
        synchronize = 's',
        trim_left = '<',
        trim_right = '>',
        -- go_in_plus = '<CR>',
      },
      windows = {
        max_number = math.huge,
        preview = true,
        width_focus = 50,
        width_nofocus = 15,
        width_preview = 80,
      },
      options = {
        permanent_delete = true,
        use_as_default_explorer = true,
      },
    }

    -- Key mappings for Mini.files

    vim.keymap.set('n', '<leader>ed', function()
      local current_file = vim.api.nvim_buf_get_name(0)
      if current_file ~= '' then
        mini_files.open(vim.fn.fnamemodify(current_file, ':h'))
      else
        mini_files.open()
      end
    end, { desc = 'Mini.files (current file)' })

    vim.keymap.set('n', '<leader>ef', function()
      mini_files.open(vim.fn.getcwd())
    end, { desc = 'Mini.files (root)' })
  end,
}

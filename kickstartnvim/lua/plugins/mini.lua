-- Collection of various small independent plugins/modules
return {
  'echasnovski/mini.nvim',
  config = function()
    -- Enhanced textobjects: e.g. va) selects around paren, yinq yanks inside next quote, ci' changes inside quote.
    require('mini.ai').setup { n_lines = 500 }

    -- Surround mappings: saiw) add, sd' delete, sr)' replace, etc.
    require('mini.surround').setup {
      mappings = {
        add = '<leader>da', -- Add surrounding in Normal and Visual modes
        delete = '<leader>dd', -- Delete surrounding
        find = '<leader>df', -- Find surrounding (to the right)
        find_left = '<leader>dF', -- Find surrounding (to the left)
        highlight = '<leader>dh', -- Highlight surrounding
        replace = '<leader>dr', -- Replace surrounding
        update_n_lines = '<leader>dg', -- Update `n_lines`
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
    -- Mini.move for moving text
    --
    require('mini.move').setup {
      mappings = {
        left = '<M-Left>',
        right = '<M-Right>',
        down = '<M-Down>',
        up = '<M-Up>',
        line_left = '<M-Left>',
        line_right = '<M-Right>',
        line_down = '<M-Down>',
        line_up = '<M-Up>',
      },
    }

    -- Mini.diff for visualizing diffs
    require('mini.diff').setup {
      mappings = {
        apply = '',
        reset = '',
        textobject = '',
        goto_first = '',
        goto_prev = '',
        goto_next = '',
        goto_last = '',
      },
    }

    -- Key mapping for Mini.diff
    vim.keymap.set('n', '<leader>-', function()
      require('mini.diff').toggle_overlay()
    end, { desc = 'Diff view' })

    -- Mini.completion for basic completion
    require('mini.completion').setup()

    -- Mini.operators for replace operator
    require('mini.operators').setup {
      replace = {
        prefix = 'R',
      },
      evaluate = {
        prefix = 'g=',

        -- Function which does the evaluation
        func = nil,
      },
    }
  end,
}

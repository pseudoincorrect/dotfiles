return {
  'echasnovski/mini.move',
  version = '*',
  config = function()
    require('mini.move').setup {
      -- Customize the keybindings here
      mappings = {
        left = '<C-S-h>', -- Move selection left with Alt+h
        right = '<C-S-l>', -- Move selection right with Alt+l
        down = '<C-S-j>', -- Move selection down with Alt+j
        up = '<C-S-k>', -- Move selection up with Alt+k
        line_left = '<C-S-H>', -- Move current line left
        line_right = '<C-S-L>', -- Move current line right
        line_down = '<C-S-J>', -- Move current line down
        line_up = '<C-S-K>', -- Move current line up
      },
    }
  end,
}

-- Color scheme and UI theme configurations
local gh = function(r)
  return 'https://github.com/' .. r
end

vim.pack.add {
  gh 'folke/tokyonight.nvim',
  gh 'loctvl842/monokai-pro.nvim',
}

-- Tokyonight setup
require('tokyonight').setup {
  transparent = true,
  styles = {
    sidebars = 'transparent',
    floats = 'transparent',
  },
}
vim.cmd.hi 'Comment gui=none'

-- Monokai Pro with Spectrum filter (active theme)
require('monokai-pro').setup {
  transparent_background = true,
  terminal_colors = true,
  devicons = true,
  filter = 'spectrum',
  inc_search = 'background',
  background_clear = {
    'float_win',
    'toggleterm',
    'which-key',
    'renamer',
  },
  plugins = {
    bufferline = {
      underline_selected = false,
      underline_visible = false,
    },
    indent_blankline = {
      context_highlight = 'default',
      context_start_underline = false,
    },
  },
}

-- Activate colorscheme
vim.cmd.colorscheme 'monokai-pro'

-- Custom highlight overrides
vim.cmd.hi 'Visual guibg=#4a4a5a'
vim.cmd.hi 'WinBarPath guifg=#888888 gui=NONE guibg=NONE'
vim.cmd.hi 'WinBarFilename guifg=#ffaa44 gui=bold guibg=NONE'
vim.cmd.hi 'WinBar guifg=#ffaa44 gui=bold guibg=NONE'
vim.cmd.hi 'WinBarNC guifg=#cc8833 gui=bold guibg=NONE'
vim.cmd.hi 'Normal guibg=#101010'
vim.cmd.hi 'CursorLine guibg=#142a15'
vim.cmd.hi 'WinSeparator guifg=#39ff14 guibg=NONE'

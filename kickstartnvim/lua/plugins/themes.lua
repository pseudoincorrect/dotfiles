-- Shared function to setup cursor line and visual highlighting
local function setup_cursor_highlights()
  -- Custom highlighting for current line
  vim.cmd.hi 'CursorLine guibg=#0c4e09'
  -- Lighter visual mode selection for better visibility
  vim.cmd.hi 'Visual guibg=#4a4a5a'
  -- Enhanced file path visibility in winbar
  vim.cmd.hi 'WinBarPath guifg=#888888 gui=NONE guibg=NONE'
  vim.cmd.hi 'WinBarFilename guifg=#ffaa44 gui=bold guibg=NONE'
  vim.cmd.hi 'WinBar guifg=#ffaa44 gui=bold guibg=NONE'
  vim.cmd.hi 'WinBarNC guifg=#cc8833 gui=bold guibg=NONE'

  -- Flash plugin highlighting for better visibility
  vim.cmd.hi 'FlashLabel guifg=#ffffff guibg=#ff6b6b gui=bold'
  vim.cmd.hi 'FlashMatch guifg=#ffffff guibg=#4ecdc4 gui=bold'
  vim.cmd.hi 'FlashCurrent guifg=#000000 guibg=#ffe66d gui=bold'
  vim.cmd.hi 'FlashBackdrop guifg=#666666'
end

return {
  -- tokyonight.nvim colorscheme
  {
    'folke/tokyonight.nvim',
    priority = 1000,
    opts = {
      transparent = true,
      styles = {
        sidebars = 'transparent',
        floats = 'transparent',
      },
    },
    init = function()
      -- Other styles: 'tokyonight-storm', 'tokyonight-moon', 'tokyonight-day'.
      vim.cmd.hi 'Comment gui=none'
    end,
  },

  -- Monokai Pro theme with Spectrum filter
  {
    'loctvl842/monokai-pro.nvim',
    priority = 1000,
    opts = {
      transparent_background = true,
      terminal_colors = true,
      devicons = true,
      filter = 'spectrum',
      inc_search = 'background',
      background_clear = {
        'float_win',
        'toggleterm',
        'telescope',
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
    },
    config = function(_, opts)
      require('monokai-pro').setup(opts)
    end,
  },

  -- Theme setup - handles colorscheme selection and custom highlights
  {
    '',
    name = 'theme-setup',
    priority = 999,
    config = function()
      -- Select active colorscheme (uncomment one)
      -- vim.cmd.colorscheme 'tokyonight-night'
      vim.cmd.colorscheme 'monokai-pro'

      -- Apply custom highlights
      setup_cursor_highlights()
    end,
  },
}

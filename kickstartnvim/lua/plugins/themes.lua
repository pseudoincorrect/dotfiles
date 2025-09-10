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
      vim.cmd.colorscheme 'tokyonight-night'
      vim.cmd.hi 'Comment gui=none'
      -- Custom highlighting for current line (green)
      vim.cmd.hi 'CursorLine guibg=#2d4f3e'
      -- Lighter visual mode selection for better visibility
      vim.cmd.hi 'Visual guibg=#4a4a5a'
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
      -- Uncomment to use Monokai Pro Spectrum instead of Tokyo Night
      vim.cmd.colorscheme 'monokai-pro'
    end,
  },
}

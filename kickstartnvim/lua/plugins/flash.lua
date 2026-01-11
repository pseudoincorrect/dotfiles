return {
  'folke/flash.nvim',
  event = 'VeryLazy',
  opts = {},
  config = function(_, opts)
    require('flash').setup(opts)
  end,
  keys = {
    {
      's',
      mode = { 'n', 'x', 'o' },
      function()
        require('flash').jump()
      end,
      desc = 'Flash',
    },
    {
      '<A-s>',
      mode = { 'n', 'x', 'o' },
      function()
        require('flash').treesitter()
      end,
      desc = 'Flash Treesitter',
    },
    {
      'r',
      mode = 'o',
      function()
        require('flash').remote()
      end,
      desc = 'Remote Flash',
    },
    {
      '<C-v>',
      mode = { 'o', 'x' },
      function()
        require('flash').treesitter_search()
      end,
      desc = 'Treesitter Search',
    },
    {
      'S',
      mode = 'n',
      function()
        require('flash').jump {
          action = function(match, state)
            state:hide()
            vim.api.nvim_set_current_win(match.win)
            vim.api.nvim_win_set_cursor(match.win, match.pos)
            vim.lsp.buf.definition()
          end,
        }
      end,
      desc = 'Flash Go to Definition',
    },
  },
}

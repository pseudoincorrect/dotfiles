return {
  'folke/flash.nvim',
  event = 'VeryLazy',
  opts = { modes = { char = { enabled = false } } },
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
      'S',
      mode = { 'n', 'x', 'o' },
      function()
        require('flash').treesitter()
      end,
      desc = 'Flash Treesitter',
    },
  },
}

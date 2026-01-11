return {
  'Exafunction/windsurf.nvim',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'hrsh7th/nvim-cmp',
  },
  config = function()
    require('codeium').setup {}
  end,
  keys = {
    { '<leader>at', '<cmd>Codeium Toggle<cr>', desc = 'AI Toggle' },
  },
}

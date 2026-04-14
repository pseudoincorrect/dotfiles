-- Snacks.nvim - Collection of small QoL plugins
local gh = function(r)
  return 'https://github.com/' .. r
end

vim.pack.add { gh 'folke/snacks.nvim' }

require('snacks').setup {
  -- Big file performance optimizations - preserve folds
  bigfile = {
    enabled = true,
    notify = true,
    size = 300 * 1024, -- 1.5MB
    setup = function(ctx)
      vim.opt_local.foldmethod = 'indent'
      vim.opt_local.foldenable = true
      vim.opt_local.foldlevelstart = 99
    end,
  },
  -- Indent scope animations
  indent = {
    enabled = true,
    animate = {
      enabled = true,
    },
  },
}

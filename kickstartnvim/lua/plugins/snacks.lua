-- Snacks.nvim - Collection of small QoL plugins
return {
  'folke/snacks.nvim',
  priority = 1000,
  lazy = false,
  config = function()
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
  end,
}

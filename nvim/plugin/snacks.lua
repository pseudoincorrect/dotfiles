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

-- Interactive JSON viewer (fx) in a floating terminal
vim.keymap.set('n', '<leader>x', function()
  local file = vim.api.nvim_buf_get_name(0)
  if file == '' then
    vim.notify('fx: buffer has no file', vim.log.levels.WARN)
    return
  end
  if vim.bo.modified then
    vim.cmd 'silent write'
  end
  require('snacks').terminal({ 'fx', file }, {
    win = { position = 'float', border = 'rounded', width = 0.9, height = 0.9 },
  })
end, { desc = 'View file with fx' })

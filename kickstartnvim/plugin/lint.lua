-- Code linting with nvim-lint
local gh = function(r)
  return 'https://github.com/' .. r
end

vim.pack.add { gh 'mfussenegger/nvim-lint' }

local lint = require 'lint'
lint.linters_by_ft = {
  -- markdown = { 'markdownlint' },
}

local lint_augroup = vim.api.nvim_create_augroup('lint', { clear = true })
vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWritePost', 'InsertLeave' }, {
  group = lint_augroup,
  callback = function()
    if vim.opt_local.modifiable:get() then
      lint.try_lint()
    end
  end,
})

-- Code formatting with conform.nvim
local gh = function(r)
  return 'https://github.com/' .. r
end

vim.pack.add { gh 'stevearc/conform.nvim' }

require('conform').setup {
  notify_on_error = false,
  format_on_save = function(bufnr)
    local disable_filetypes = { c = true, cpp = true, yaml = true, yml = true }
    local lsp_format_opt
    if disable_filetypes[vim.bo[bufnr].filetype] then
      lsp_format_opt = 'never'
    else
      lsp_format_opt = 'fallback'
    end
    return {
      timeout_ms = 500,
      lsp_format = lsp_format_opt,
    }
  end,
  formatters_by_ft = {
    lua = { 'stylua' },
    javascript = { 'prettierd', stop_after_first = true },
    typescript = { 'prettierd', stop_after_first = true },
    bash = { 'shfmt' },
    sh = { 'shfmt' },
  },
}

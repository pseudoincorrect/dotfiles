-- Treesitter - Highlight, edit, and navigate code
local gh = function(r)
  return 'https://github.com/' .. r
end

vim.pack.add { gh 'nvim-treesitter/nvim-treesitter' }

-- Install parsers (async)
local parsers = { 'bash', 'c', 'diff', 'go', 'html', 'lua', 'luadoc', 'markdown', 'markdown_inline', 'query', 'sql', 'vim', 'vimdoc' }
require('nvim-treesitter.install').install(parsers)

-- Enable treesitter highlighting and indentation for all filetypes with a parser
vim.api.nvim_create_autocmd('FileType', {
  callback = function(ev)
    pcall(vim.treesitter.start)
    if ev.match ~= 'ruby' then
      pcall(function()
        vim.bo[ev.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
      end)
    end
  end,
})

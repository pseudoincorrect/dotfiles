-- Auto-completion with nvim-cmp
local gh = function(r)
  return 'https://github.com/' .. r
end

vim.pack.add {
  gh 'hrsh7th/cmp-nvim-lsp',
  gh 'hrsh7th/cmp-path',
  gh 'hrsh7th/nvim-cmp',
}

local cmp = require 'cmp'

cmp.setup {
  completion = { completeopt = 'menu,menuone,noinsert,noselect' },
  mapping = cmp.mapping.preset.insert {
    ['<C-n>'] = cmp.mapping.select_next_item(),
    ['<C-p>'] = cmp.mapping.select_prev_item(),
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<CR>'] = cmp.mapping.confirm { select = true },
  },
  sources = {
    { name = 'nvim_lsp' },
    { name = 'path' },
  },
}

-- Auto-completion with nvim-cmp
local gh = function(r)
  return 'https://github.com/' .. r
end

vim.pack.add {
  gh 'hrsh7th/cmp-nvim-lsp',
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
    ['<C-,>'] = cmp.mapping.complete(),
    ['<CR>'] = cmp.mapping.confirm { select = true },
  },
  sources = {
    -- LSP only. Drop snippet items, and word items (kind "Text": words from the file)
    {
      name = 'nvim_lsp',
      entry_filter = function(entry)
        local kind = entry:get_kind()
        return kind ~= cmp.lsp.CompletionItemKind.Snippet and kind ~= cmp.lsp.CompletionItemKind.Text
      end,
    },
  },
}

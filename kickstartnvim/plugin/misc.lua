-- Small standalone plugins
local gh = function(r)
  return 'https://github.com/' .. r
end

vim.pack.add {
  -- Utilities
  gh 'tpope/vim-sleuth',
  gh 'nvim-lua/plenary.nvim',
  gh 'Bilal2453/luvit-meta',
  gh 'folke/lazydev.nvim',
  gh 'folke/todo-comments.nvim',
  gh 'rmagatti/auto-session',
  gh 'gbprod/yanky.nvim',
  gh 'Aasim-A/scrollEOF.nvim',
  gh 'MeanderingProgrammer/render-markdown.nvim',
  { src = gh 'lukas-reineke/indent-blankline.nvim', name = 'indent-blankline.nvim' },
  { src = gh 'mg979/vim-visual-multi', version = 'master' },
  gh 'nvim-pack/nvim-spectre',
  gh 'pmizio/typescript-tools.nvim',
}

-- Lua development support
require('lazydev').setup {
  library = {
    { path = 'luvit-meta/library', words = { 'vim%.uv' } },
  },
}

-- Highlight todo, notes, etc in comments
require('todo-comments').setup { signs = false }

-- Session management
require('auto-session').setup {
  auto_restore = true,
  auto_save = true,
  auto_create = true,
  suppressed_dirs = { '~/', '~/Projects', '~/Downloads', '/' },
  session_lens = {
    load_on_setup = true,
    theme_conf = { border = true },
    previewer = false,
  },
  pre_save_cmds = { 'Neotree close' },
}

-- Yank history
require('yanky').setup {}

-- Scroll past EOF
require('scrollEOF').setup {}

-- Enhanced markdown rendering (disabled by default, toggle with keymaps)
require('render-markdown').setup { enabled = false }
vim.keymap.set('n', '<leader>cmt', '<cmd>RenderMarkdown toggle<cr>', { desc = 'Toggle Render Markdown' })
vim.keymap.set('n', '<leader>cme', '<cmd>RenderMarkdown enable<cr>', { desc = 'Enable Render Markdown' })
vim.keymap.set('n', '<leader>cmd', '<cmd>RenderMarkdown disable<cr>', { desc = 'Disable Render Markdown' })

-- Indentation guides
require('ibl').setup {}

-- Project-wide search and replace
require('spectre').setup { open_cmd = 'noswapfile vnew' }
vim.keymap.set('n', '<leader>R', function()
  require('spectre').open()
end, { desc = 'Replace in files' })

-- TypeScript tools
require('typescript-tools').setup {}

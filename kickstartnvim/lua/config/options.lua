-- Vim Options Configuration
local M = {}

function M.setup()
  -- [[ Vim Options ]]
  vim.opt.number = true -- Enable line numbers for better navigation
  vim.opt.relativenumber = false
  vim.opt.mouse = 'a'
  vim.opt.showmode = false
  vim.opt.breakindent = true
  vim.opt.undofile = true
  vim.opt.ignorecase = true
  vim.opt.smartcase = true
  vim.opt.hlsearch = false
  vim.opt.incsearch = true
  vim.opt.signcolumn = 'yes'
  vim.opt.updatetime = 250
  vim.opt.timeoutlen = 300
  vim.opt.splitright = true
  vim.opt.splitbelow = true
  vim.opt.list = true
  vim.opt.listchars = { tab = '│ ', trail = '·', nbsp = '␣' }
  vim.opt.inccommand = 'split'
  vim.opt.cursorline = true
  vim.opt.scrolloff = 17
  vim.opt.softtabstop = 2
  vim.opt.shiftwidth = 2
  vim.opt.tabstop = 2
  vim.opt.expandtab = true
  vim.opt.textwidth = 0
  vim.opt.wrapmargin = 0
  vim.opt.wrap = true
  vim.opt.linebreak = true
  vim.opt.winbar = '  📄  %f'
  vim.opt.cmdheight = 1
  vim.opt.swapfile = false
  vim.opt.autowrite = true
  vim.opt.autoread = true
  vim.opt.lazyredraw = true -- Performance improvement
  vim.opt.colorcolumn = '80' -- Code line length guide

  -- Window appearance and borders
  vim.opt.fillchars = {
    horiz = '━',
    horizup = '┻',
    horizdown = '┳',
    vert = '┃',
    vertleft = '┫',
    vertright = '┣',
    verthoriz = '╋',
  }
  vim.opt.laststatus = 3 -- Global statusline

  -- Sync clipboard after UI loads
  vim.schedule(function()
    vim.opt.clipboard = 'unnamedplus'
  end)
end

return M

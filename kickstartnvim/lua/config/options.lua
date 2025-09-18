-- Vim Options Configuration
local M = {}

function M.setup()
  vim.opt.number = true
  vim.opt.relativenumber = true
  vim.opt.mouse = 'a'
  vim.opt.showmode = false
  vim.opt.breakindent = true
  vim.opt.undofile = true
  vim.opt.ignorecase = true
  vim.opt.smartcase = true
  vim.opt.hlsearch = false
  vim.opt.incsearch = true
  vim.opt.signcolumn = 'yes'
  vim.opt.updatetime = 100
  vim.opt.timeoutlen = 300
  vim.opt.splitright = true
  vim.opt.splitbelow = true
  vim.opt.list = true
  vim.opt.listchars = { tab = '│ ', trail = '·', nbsp = '␣' }
  vim.opt.inccommand = 'split'
  vim.opt.cursorline = false
  vim.opt.scrolloff = 17
  vim.opt.softtabstop = 2
  vim.opt.shiftwidth = 2
  vim.opt.tabstop = 2
  vim.opt.expandtab = true
  vim.opt.textwidth = 0
  vim.opt.wrapmargin = 0
  vim.opt.wrap = true
  vim.opt.linebreak = true
  vim.opt.winbar = '%{%v:lua.require("config.options").winbar()%}'
  vim.opt.cmdheight = 1
  vim.opt.swapfile = false
  vim.opt.autowrite = true
  vim.opt.autoread = true
  vim.opt.lazyredraw = false

  -- Folding configuration
  vim.opt.foldmethod = 'indent'
  vim.opt.foldlevelstart = 99
  vim.opt.foldenable = true

  -- Window appearance and borders
  vim.opt.fillchars = {
    horiz = '━',
    horizup = '┻',
    horizdown = '┳',
    vert = '┃',
    vertleft = '┫',
    vertright = '┣',
    verthoriz = '╋',
    eob = ' ',
  }
  vim.opt.laststatus = 3 -- Global statusline

  -- Sync clipboard after UI loads
  vim.schedule(function()
    vim.opt.clipboard = 'unnamedplus'
  end)
end

-- Improve the file path display in the winbar
function M.winbar()
  local filepath = vim.fn.expand '%:~'
  if filepath == '' then
    return ''
  end

  local dir = vim.fn.fnamemodify(filepath, ':h')
  local filename = vim.fn.fnamemodify(filepath, ':t')

  if dir == '.' or dir == '' then
    return '   %#WinBarFilename#' .. filename .. '%*   '
  else
    return '   %#WinBarPath#' .. dir .. '/%*%#WinBarFilename#' .. filename .. '%*   '
  end
end

return M

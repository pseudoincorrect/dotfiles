-- Vim Options Configuration
local M = {}

function M.setup()
  vim.opt.autoread = true
  vim.opt.autowrite = true
  vim.opt.breakindent = true
  vim.opt.cmdheight = 1
  vim.opt.cursorline = true
  vim.opt.expandtab = true
  vim.opt.foldenable = true
  vim.opt.foldlevelstart = 99
  vim.opt.foldmethod = 'indent'
  vim.opt.hlsearch = false
  vim.opt.ignorecase = true
  vim.opt.inccommand = 'split'
  vim.opt.incsearch = true
  vim.opt.laststatus = 3
  vim.opt.lazyredraw = false
  vim.opt.linebreak = true
  vim.opt.list = true
  vim.opt.listchars = { tab = '│ ', trail = '·', nbsp = '␣' }
  vim.opt.mouse = 'a'
  vim.opt.number = true
  vim.opt.relativenumber = true
  vim.opt.scrolloff = 17
  vim.opt.shiftwidth = 2
  vim.opt.showmode = true
  vim.opt.signcolumn = 'yes'
  vim.opt.smartcase = true
  vim.opt.softtabstop = 2
  vim.opt.splitbelow = true
  vim.opt.splitright = true
  vim.opt.swapfile = false
  vim.opt.tabstop = 2
  vim.opt.textwidth = 0
  vim.opt.timeoutlen = 300
  vim.opt.title = true
  vim.opt.titlestring = vim.fs.basename(vim.fn.getcwd())
  vim.opt.undofile = true
  vim.opt.updatetime = 100
  vim.opt.winbar = '%{%v:lua.require("config.options").winbar()%}'
  vim.opt.wrap = true
  vim.opt.wrapmargin = 0
  vim.opt.wrapscan = false
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

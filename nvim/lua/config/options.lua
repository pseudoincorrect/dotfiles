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
  vim.opt.wrapscan = false
  vim.opt.laststatus = 3
  vim.opt.lazyredraw = false
  vim.opt.linebreak = true
  vim.opt.list = true
  vim.opt.listchars = { tab = '│ ', trail = '·', nbsp = '␣' }
  vim.opt.mouse = 'a'
  vim.opt.number = true
  vim.opt.relativenumber = false
  vim.opt.scrolloff = 10
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
  -- vim.opt.title = true
  -- vim.opt.titlestring = vim.fs.basename(vim.fn.getcwd())
  vim.opt.undofile = true
  vim.opt.updatetime = 100
  -- Set the winbar per window, not globally. For a global-local option, an empty local
  -- value means "use the global value", so other plugins (snacks) cannot remove a global winbar.
  vim.api.nvim_create_autocmd({ 'VimEnter', 'BufWinEnter', 'WinNew' }, {
    group = vim.api.nvim_create_augroup('winbar', { clear = true }),
    callback = function()
      local win = vim.api.nvim_get_current_win()
      if vim.api.nvim_win_get_config(win).relative == '' and not vim.bo.filetype:match '^snacks_' then
        vim.wo[win].winbar = '%{%v:lua.require("config.options").winbar()%}'
      end
    end,
  })
  vim.opt.wrap = true
  vim.opt.wrapmargin = 0
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

-- Winbar colors (monokai-pro spectrum): a bold light path and a bright file name.
-- The NC groups are for the windows that do not have the focus.
local function winbar_highlights()
  local hl = function(name, opts)
    vim.api.nvim_set_hl(0, name, opts)
  end
  hl('WinBarPath', { fg = '#d0cfd1', bold = true })
  hl('WinBarFilename', { fg = '#fce566', bold = true })
  hl('WinBarPathNC', { fg = '#727072' })
  hl('WinBarFilenameNC', { fg = '#a9a7aa' })
  hl('WinBarPinned', { fg = '#ff6188', bold = true })
end
winbar_highlights()
vim.api.nvim_create_autocmd('ColorScheme', {
  group = vim.api.nvim_create_augroup('winbar-highlights', { clear = true }),
  callback = winbar_highlights,
})

-- Improve the file path display in the winbar
function M.winbar()
  local filepath = vim.fn.expand '%:~'
  if filepath == '' then
    return ''
  end
  -- While Neovim draws the winbar, the current window is the drawn window,
  -- and g:actual_curwin is the window that has the focus.
  local active = vim.api.nvim_get_current_win() == tonumber(vim.g.actual_curwin)
  local nc = active and '' or 'NC'
  local dir = vim.fn.fnamemodify(filepath, ':h')
  local filename = vim.fn.fnamemodify(filepath, ':t')
  local path = ''
  if dir ~= '.' and dir ~= '' then
    path = '%#WinBarPath' .. nc .. '#' .. dir:gsub('%%', '%%%%') .. '/'
  end
  local paren = '%#WinBarPath' .. nc .. '#'
  -- Pin mark for the files pinned in the buffer cycle (<C-h>, see plugin/bufcycle.lua)
  local pin = vim.b.bufcycle_pinned and ('%#WinBarPinned#' .. (vim.g.have_nerd_font and '󰐃 ' or '[pin] ')) or ''
  -- A '%=' on each side puts the same space on the left and on the right: the text is centered.
  return '%=' .. pin .. paren .. '[ ' .. path .. '%#WinBarFilename' .. nc .. '#' .. filename:gsub('%%', '%%%%') .. paren .. ' ]%*%='
end

return M

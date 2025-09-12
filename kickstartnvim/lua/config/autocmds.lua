-- Autocommands Configuration
local M = {}

function M.setup()
  -- Highlight when yanking (copying) text
  vim.api.nvim_create_autocmd('TextYankPost', {
    desc = 'Highlight when yanking (copying) text',
    group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
    callback = function()
      vim.highlight.on_yank()
    end,
  })

  -- Window border and distinction settings
  vim.api.nvim_create_autocmd({ 'WinEnter', 'BufWinEnter' }, {
    desc = 'Highlight active window and enable cursor line',
    group = vim.api.nvim_create_augroup('window-distinction', { clear = true }),
    callback = function()
      vim.wo.winhighlight = 'Normal:Normal,NormalNC:NormalNC'
      vim.wo.cursorline = true
    end,
  })

  vim.api.nvim_create_autocmd('WinLeave', {
    desc = 'Dim inactive window and disable cursor line',
    group = vim.api.nvim_create_augroup('window-distinction', { clear = false }),
    callback = function()
      vim.wo.winhighlight = 'Normal:NormalNC,NormalNC:NormalNC'
      vim.wo.cursorline = false
    end,
  })

  -- Set up window borders for floating windows
  vim.api.nvim_create_autocmd('ColorScheme', {
    desc = 'Set window border colors',
    group = vim.api.nvim_create_augroup('window-borders', { clear = true }),
    callback = function()
      vim.api.nvim_set_hl(0, 'FloatBorder', { fg = '#00ff00' })
      vim.api.nvim_set_hl(0, 'WinSeparator', { fg = '#00ff00' })
    end,
  })
end

return M

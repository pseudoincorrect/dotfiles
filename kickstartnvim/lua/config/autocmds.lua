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
    desc = 'Highlight active window border',
    group = vim.api.nvim_create_augroup('window-distinction', { clear = true }),
    callback = function()
      vim.wo.winhighlight = 'Normal:Normal,NormalNC:NormalNC'
    end,
  })

  vim.api.nvim_create_autocmd('WinLeave', {
    desc = 'Dim inactive window',
    group = vim.api.nvim_create_augroup('window-distinction', { clear = false }),
    callback = function()
      vim.wo.winhighlight = 'Normal:NormalNC,NormalNC:NormalNC'
    end,
  })

  -- Set up window borders for floating windows
  vim.api.nvim_create_autocmd('ColorScheme', {
    desc = 'Set window border colors',
    group = vim.api.nvim_create_augroup('window-borders', { clear = true }),
    callback = function()
      vim.api.nvim_set_hl(0, 'FloatBorder', { fg = '#00ff00', bg = 'NONE' })
      vim.api.nvim_set_hl(0, 'NormalFloat', { bg = '#1a1b26' })
      vim.api.nvim_set_hl(0, 'NormalNC', { bg = '#16161e' })
      vim.api.nvim_set_hl(0, 'WinSeparator', { fg = '#00ff00', bg = 'NONE' })
    end,
  })
end

return M

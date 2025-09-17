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

  -- Helper function to close all terminal jobs
  local function close_terminal_jobs()
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
      if vim.api.nvim_buf_is_valid(buf) and vim.bo[buf].buftype == 'terminal' then
        local job_id = vim.b[buf].terminal_job_id
        if job_id then
          vim.fn.jobstop(job_id)
          vim.bo[buf].modified = false
          -- Force delete terminal buffers
          vim.api.nvim_buf_delete(buf, { force = true })
        end
      end
    end
  end

  -- Auto-close terminals before quit commands
  vim.api.nvim_create_autocmd({ 'QuitPre', 'VimLeavePre' }, {
    desc = 'Close terminal jobs before quitting',
    group = vim.api.nvim_create_augroup('terminal-auto-close', { clear = true }),
    callback = close_terminal_jobs,
  })

  -- Auto enter insert mode when focusing on terminal
  vim.api.nvim_create_autocmd({ 'BufEnter', 'WinEnter', 'TermOpen' }, {
    desc = 'Auto enter insert mode in terminal',
    group = vim.api.nvim_create_augroup('terminal-insert-mode', { clear = true }),
    callback = function()
      if vim.bo.buftype == 'terminal' then
        vim.cmd 'startinsert'
      end
    end,
  })

  -- Optimize for large files (>1MB)
  vim.api.nvim_create_autocmd('BufReadPre', {
    desc = 'Optimize settings for large files',
    group = vim.api.nvim_create_augroup('large-file-optimization', { clear = true }),
    callback = function(args)
      local buf = args.buf
      local filename = args.match
      -- Check file size
      local ok, stats = pcall(vim.loop.fs_stat, filename)
      if not ok or not stats then
        return
      end
      -- If file is larger than 100kB, optimize for performance
      if stats.size > 1024 * 100 then
        vim.b[buf].large_file = true
        -- Disable syntax highlighting
        vim.bo[buf].syntax = 'off'
        -- Disable spell checking
        vim.wo.spell = false
        -- Disable relative line numbers (keep absolute)
        vim.wo.relativenumber = false
        -- Reduce some expensive options
        vim.bo[buf].swapfile = false
        vim.wo.cursorline = false
        vim.wo.cursorcolumn = false
        -- Disable some visual effects
        vim.wo.list = false
        vim.wo.colorcolumn = ''
        -- Set faster redraw
        vim.o.lazyredraw = true
        -- Disable auto-completion
        vim.bo[buf].omnifunc = ''
        vim.bo[buf].completefunc = ''
      end
    end,
  })

  -- Disable LSP and treesitter for large files
  vim.api.nvim_create_autocmd('BufRead', {
    desc = 'Disable LSP and treesitter for large files',
    group = vim.api.nvim_create_augroup('large-file-optimization', { clear = false }),
    callback = function(args)
      local buf = args.buf
      if vim.b[buf].large_file then
        -- Disable LSP
        vim.schedule(function()
          local clients = vim.lsp.get_active_clients { bufnr = buf }
          for _, client in ipairs(clients) do
            vim.lsp.buf_detach_client(buf, client.id)
          end
        end)
        -- Disable treesitter
        local has_ts, ts_configs = pcall(require, 'nvim-treesitter.configs')
        if has_ts then
          vim.schedule(function()
            vim.cmd 'TSBufDisable highlight'
            vim.cmd 'TSBufDisable indent'
          end)
        end
        -- Show notification
        vim.schedule(function()
          vim.notify('Large file detected: Performance optimizations enabled', vim.log.levels.INFO)
        end)
      end
    end,
  })
end

return M

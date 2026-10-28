-- Autocommands Configuration
local M = {}

function M.setup()
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
  --
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

  -- Auto-close terminals before quit commands
  vim.api.nvim_create_autocmd({ 'QuitPre', 'VimLeavePre' }, {
    desc = 'Close terminal jobs before quitting',
    group = vim.api.nvim_create_augroup('terminal-auto-close', { clear = true }),
    callback = close_terminal_jobs,
  })

  -- Update title when directory changes
  vim.api.nvim_create_autocmd('DirChanged', {
    desc = 'Update title when directory changes',
    group = vim.api.nvim_create_augroup('update-title', { clear = true }),
    callback = function()
      vim.opt.titlestring = vim.fs.basename(vim.fn.getcwd())
    end,
  })

  -- Organize Go imports via gopls before the save-time format
  vim.api.nvim_create_autocmd('BufWritePre', {
    desc = 'Organize Go imports on save',
    group = vim.api.nvim_create_augroup('go-organize-imports', { clear = true }),
    pattern = '*.go',
    callback = function(event)
      local params = vim.lsp.util.make_range_params(0, 'utf-16')
      params.context = { only = { 'source.organizeImports' } }
      local res = vim.lsp.buf_request_sync(event.buf, 'textDocument/codeAction', params, 1000)
      for client_id, r in pairs(res or {}) do
        local client = vim.lsp.get_client_by_id(client_id)
        for _, action in ipairs(r.result or {}) do
          if action.edit and client then
            vim.lsp.util.apply_workspace_edit(action.edit, client.offset_encoding)
          end
        end
      end
    end,
  })

  -- Open neo-tree on startup
  vim.api.nvim_create_autocmd('VimEnter', {
    desc = 'Open neo-tree on startup',
    group = vim.api.nvim_create_augroup('neotree-on-start', { clear = true }),
    callback = function()
      vim.schedule(function()
        vim.cmd 'Neotree show'
      end)
    end,
  })
end

return M

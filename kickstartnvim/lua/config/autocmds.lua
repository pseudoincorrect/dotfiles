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
end

return M

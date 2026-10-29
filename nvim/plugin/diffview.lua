-- Branch diffs with a changed-files tree, and file history
local gh = function(r)
  return 'https://github.com/' .. r
end

vim.pack.add { gh 'sindrets/diffview.nvim' }

-- Focus the new-code side of the diff (b / main window)
local function focus_new()
  local view = require('diffview.lib').get_current_view()
  if view and view.cur_layout then
    view.cur_layout:get_main_win():focus()
  end
end

require('diffview').setup {
  enhanced_diff_hl = true,
  keymaps = {
    view = { { 'n', '<leader>l', focus_new, { desc = 'Focus the new-code side' } } },
    file_panel = { { 'n', '<leader>l', focus_new, { desc = 'Focus the new-code side' } } },
    file_history_panel = { { 'n', '<leader>l', focus_new, { desc = 'Focus the new-code side' } } },
  },
}

-- origin's default branch (e.g. origin/main), falling back to main
local function default_branch()
  local out = vim.fn.systemlist { 'git', 'symbolic-ref', '--short', 'refs/remotes/origin/HEAD' }
  if vim.v.shell_error == 0 and out[1] then
    return out[1]
  end
  return 'main'
end

-- Diff the current branch against a base, like a PR (changes since the merge-base)
vim.keymap.set('n', '<leader>hd', function()
  vim.ui.input({ prompt = 'Diff against: ', default = default_branch() }, function(base)
    if base and base ~= '' then
      vim.cmd('DiffviewOpen ' .. base .. '...HEAD')
    end
  end)
end, { desc = 'Diff branch against base' })
vim.keymap.set('n', '<leader>hw', '<cmd>DiffviewOpen<cr>', { desc = 'Diff working tree' })
vim.keymap.set('n', '<leader>hh', '<cmd>DiffviewFileHistory %<cr>', { desc = 'File history' })
vim.keymap.set('n', '<leader>hH', '<cmd>DiffviewFileHistory<cr>', { desc = 'Branch history' })
vim.keymap.set('n', '<leader>hq', '<cmd>DiffviewClose<cr>', { desc = 'Close diff view' })

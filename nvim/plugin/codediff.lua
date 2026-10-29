-- VSCode-style diffs (inline or side-by-side) with a changed-files explorer, and file history
local gh = function(r)
  return 'https://github.com/' .. r
end

vim.pack.add { gh 'esmuellert/codediff.nvim' }

require('codediff').setup {
  diff = {
    layout = 'inline', -- `t` toggles side-by-side
  },
  explorer = {
    initial_focus = 'modified',
    line_stats = { enabled = true, count_untracked = true }, -- +12 -4 per file and group
  },
  keymaps = {
    view = {
      next_hunk = '<leader>j',
      prev_hunk = '<leader>k',
    },
  },
}

-- Explorer/history panels: `l` selects like <CR>, scroll the diff without leaving the panel
vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'codediff-explorer', 'codediff-history' },
  callback = function(event)
    local function scroll(keys)
      return function()
        local _, win = require('codediff.ui.lifecycle').get_windows(vim.api.nvim_get_current_tabpage())
        if win and vim.api.nvim_win_is_valid(win) then
          vim.api.nvim_win_call(win, function()
            vim.cmd.normal { vim.keycode(keys), bang = true }
          end)
        end
      end
    end
    vim.keymap.set('n', 'l', '<CR>', { buffer = event.buf, remap = true, desc = 'Select' })
    vim.keymap.set('n', '<C-d>', scroll '<C-d>', { buffer = event.buf, desc = 'Scroll diff down' })
    vim.keymap.set('n', '<C-u>', scroll '<C-u>', { buffer = event.buf, desc = 'Scroll diff up' })
  end,
})

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
      vim.cmd('CodeDiff ' .. base .. '...HEAD')
    end
  end)
end, { desc = 'Diff branch against base' })
vim.keymap.set('n', '<leader>hw', '<cmd>CodeDiff<cr>', { desc = 'Diff working tree' })
vim.keymap.set('n', '<leader>hh', '<cmd>CodeDiff history %<cr>', { desc = 'File history' })
vim.keymap.set('n', '<leader>hH', '<cmd>CodeDiff history<cr>', { desc = 'Branch history' })

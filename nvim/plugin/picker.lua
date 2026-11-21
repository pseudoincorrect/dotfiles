-- Fuzzy finder keymaps with the snacks picker (config is in snacks.lua)
local map = vim.keymap.set
local all_modes = { 'n', 'i', 'v', 't' }

-- Return a function that opens the picker `source` with `opts`
local pick = function(source, opts)
  return function()
    Snacks.picker[source](opts)
  end
end

map('n', '<leader>sh', pick 'help', { desc = 'Help' })
map('n', '<leader>sk', pick 'keymaps', { desc = 'Keymaps' })
map('n', '<leader>sm', pick 'marks', { desc = 'Marks' })
map('n', '<leader>sp', pick 'pickers', { desc = 'Pickers' })
map('n', '<leader>sd', pick 'diagnostics_buffer', { desc = 'Diagnostics' })
map('n', '<leader>sr', pick 'resume', { desc = 'Resume' })
map('n', '<leader>so', pick 'recent', { desc = 'Old Files' })
map('n', '<leader>sc', pick 'command_history', { desc = 'Commands' })
map('n', '<leader>sT', pick 'colorschemes', { desc = 'Themes' })
map('n', '<leader>sj', pick 'jumps', { desc = 'Jumplist' })
map('n', '<leader>su', pick 'undo', { desc = 'Undos' })
map('n', '<leader>s*', pick 'grep_word', { desc = 'Current word' })
map('n', '<leader>sv', pick 'git_status', { desc = 'Changed git files' })
map('v', '<leader>sv', pick 'grep_word', { desc = 'Grep Repo with Selection' })
map('n', '<leader>sx', pick 'diagnostics_buffer', { desc = 'Problems' })
map('n', '<leader>f', pick 'files', { desc = 'Files' })
map(all_modes, '<C-f>', pick 'files', { desc = 'Files' })
map('n', '<leader>/', pick 'lines', { desc = 'Grep Buffer' })
map('n', '<leader>b', pick 'buffers', { desc = 'Buffers' })
map(all_modes, '<C-b>', pick 'buffers', { desc = 'Buffers' })
map('n', '<leader>s/', pick 'grep', { desc = 'Live Grep' })
map('n', '<leader>cs', pick 'spelling', { desc = 'Spelling Suggestions' })

-- Fuzzy search over all lines of the project (rg runs once, then fuzzy filter)
map(
  'n',
  '<leader>sf',
  pick('grep', {
    title = 'Grep Project',
    live = false,
    need_search = false,
    search = '',
    args = { '--max-columns=4096' },
  }),
  { desc = 'Live Fuzzy' }
)

-- Open terminal buffers
local terminals = function()
  vim.cmd 'stopinsert'
  vim.schedule(function()
    Snacks.picker.buffers { pattern = 'term://' }
  end)
end
map('n', '<leader>st', terminals, { desc = 'Terminals' })
map(all_modes, '<C-t>', terminals, { desc = 'Terminals' })

-- Zoxide: cd to the selected directory
map(
  'n',
  '<leader>sz',
  pick('zoxide', {
    confirm = function(picker, item)
      picker:close()
      if item then
        vim.cmd.cd(item.file)
      end
    end,
  }),
  { desc = 'Zoxide' }
)

-- Find Neovim config files
map('n', '<leader>sn', pick('files', { cwd = vim.fn.stdpath 'config' }), { desc = 'Neovim files' })

-- Find all files, also hidden and git-ignored
map('n', '<leader>F', pick('files', { hidden = true, ignored = true }), { desc = 'Files (all)' })

-- Go Packages: insert the selected package name
map(
  'n',
  '<leader>sg',
  pick('pick', {
    title = 'Go Packages',
    finder = 'proc',
    cmd = 'go',
    args = { 'list', 'all' },
    format = 'text',
    preview = 'none',
    layout = { preset = 'select' },
    confirm = function(picker, item)
      picker:close()
      if item then
        vim.api.nvim_put({ item.text }, '', true, true)
      end
    end,
  }),
  { desc = 'Go Packages' }
)

-- Find a file or directory and reveal it in the explorer (not open it)
map(
  'n',
  '<leader>E',
  pick('files', {
    title = 'Reveal in Explorer',
    cmd = 'fd',
    args = { '--type', 'd' }, -- also list directories
    confirm = function(picker, item)
      picker:close()
      if not item then
        return
      end
      local explorer = Snacks.explorer.reveal { file = Snacks.picker.util.path(item) }
      explorer:focus 'list'
    end,
  }),
  { desc = 'Reveal in Explorer' }
)

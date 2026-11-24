-- Switch buffers by recency with one key, like Alt-Tab:
-- <C-j> goes to an older buffer, <C-k> goes back to a more recent one.
-- While you press <C-j>/<C-k> in a sequence, the order stays frozen.
-- Any other key ends the sequence and puts the current buffer first.
-- The cycle has the pinned files first (in pin order), then the most recent files.
-- It has max MAX files (more if you pin more), and it wraps around at the ends.
-- <C-h> pins or unpins the current file. The winbar shows a pin mark on pinned files
-- (it reads the buffer variable vim.b.bufcycle_pinned).
-- <C-l> removes the current file from the list (the buffer stays open) and goes to
-- the most recent file. The file comes back into the list when you open it again.
--
-- The lists contain file paths, not buffer numbers. They are saved for each working
-- directory in STATE_FILE, so the pins and the order stay after you close Neovim.
-- A pinned file stays pinned when you delete its buffer: the cycle opens it again.

local MAX = 5
local MRU_SAVE = 20 -- number of recent files to save for each directory
local STATE_FILE = vim.fn.stdpath 'state' .. '/bufcycle.json'

local mru = {} ---@type string[] file paths, most recent first
local pinned = {} ---@type string[] file paths, pin order
local cycle = nil ---@type { list: string[], idx: integer }?

---@return string? path the file path of a normal file buffer
local function buf_path(buf)
  if not vim.api.nvim_buf_is_valid(buf) or not vim.bo[buf].buflisted or vim.bo[buf].buftype ~= '' then
    return nil
  end
  local name = vim.api.nvim_buf_get_name(buf)
  return name ~= '' and vim.fs.normalize(name) or nil
end

-- A path is usable when a listed buffer has it, or when the file is on disk
local function usable(path)
  local buf = vim.fn.bufnr(path)
  return (buf ~= -1 and buf_path(buf) ~= nil) or vim.uv.fs_stat(path) ~= nil
end

---@param list string[]
---@return boolean removed
local function remove(list, path)
  for i, p in ipairs(list) do
    if p == path then
      table.remove(list, i)
      return true
    end
  end
  return false
end

local function touch(buf)
  local path = buf_path(buf)
  if path then
    remove(mru, path)
    table.insert(mru, 1, path)
  end
end

local function mark(buf)
  local path = buf_path(buf)
  vim.b[buf].bufcycle_pinned = path and vim.tbl_contains(pinned, path) or nil
end

-- Open the file of a path, in a buffer that exists or in a new one
local function open(path)
  local buf = vim.fn.bufadd(path)
  vim.bo[buf].buflisted = true
  vim.api.nvim_set_current_buf(buf)
end

-- Pinned files first, then the most recent files, max MAX files (or all the pinned files)
local function cycle_list()
  local list = vim.tbl_filter(usable, pinned)
  local max = math.max(MAX, #list)
  for _, path in ipairs(mru) do
    if #list >= max then
      break
    end
    if usable(path) and not vim.tbl_contains(pinned, path) then
      table.insert(list, path)
    end
  end
  return list
end

-- Persistence: { [cwd] = { pinned = string[], mru = string[] } }
local function read_state()
  local ok, data = pcall(function()
    return vim.json.decode(table.concat(vim.fn.readfile(STATE_FILE), '\n'))
  end)
  return ok and type(data) == 'table' and data or {}
end

local function save(cwd)
  local state = read_state()
  local recent = {}
  for _, path in ipairs(mru) do
    if #recent >= MRU_SAVE then
      break
    end
    if vim.uv.fs_stat(path) then
      table.insert(recent, path)
    end
  end
  state[cwd] = (#pinned > 0 or #recent > 0) and { pinned = pinned, mru = recent } or nil
  vim.fn.mkdir(vim.fs.dirname(STATE_FILE), 'p')
  pcall(vim.fn.writefile, { vim.json.encode(state) }, STATE_FILE)
end

local function load(cwd)
  local entry = read_state()[cwd] or {}
  pinned = vim.tbl_filter(function(p)
    return vim.uv.fs_stat(p) ~= nil
  end, entry.pinned or {})
  -- Keep the files of this session first, then the saved ones
  for _, path in ipairs(entry.mru or {}) do
    if not vim.tbl_contains(mru, path) and vim.uv.fs_stat(path) then
      table.insert(mru, path)
    end
  end
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    mark(buf)
  end
end

local cwd = vim.fs.normalize(vim.fn.getcwd())
load(cwd)

local group = vim.api.nvim_create_augroup('bufcycle', { clear = true })

vim.api.nvim_create_autocmd('BufEnter', {
  group = group,
  callback = function(ev)
    if not cycle then
      touch(ev.buf)
    end
    mark(ev.buf)
  end,
})

vim.api.nvim_create_autocmd('BufWinEnter', {
  group = group,
  callback = function(ev)
    mark(ev.buf)
  end,
})

-- A deleted buffer leaves the recent list. A pinned file stays pinned.
vim.api.nvim_create_autocmd('BufDelete', {
  group = group,
  callback = function(ev)
    local path = buf_path(ev.buf)
    if path then
      remove(mru, path)
    end
  end,
})

vim.api.nvim_create_autocmd('VimLeavePre', {
  group = group,
  callback = function()
    save(cwd)
  end,
})

-- Each working directory has its own lists
vim.api.nvim_create_autocmd('DirChanged', {
  group = group,
  pattern = 'global',
  callback = function()
    save(cwd)
    cwd = vim.fs.normalize(vim.fn.getcwd())
    mru, pinned, cycle = {}, {}, nil
    load(cwd)
  end,
})

-- End the cycle on any typed key that is not <C-j> or <C-k>
vim.on_key(function(_, typed)
  if not cycle or not typed or typed == '' then
    return
  end
  local key = vim.fn.keytrans(typed)
  -- <C-j> is the same byte as <NL> (^J) in most terminals
  if key ~= '<C-J>' and key ~= '<NL>' and key ~= '<C-K>' then
    cycle = nil
    touch(vim.api.nvim_get_current_buf())
  end
end, vim.api.nvim_create_namespace 'bufcycle')

---@param step integer 1: older, -1: more recent
local function go(step)
  if not cycle then
    touch(vim.api.nvim_get_current_buf())
    local list = cycle_list()
    -- Start on the current file. In a special buffer (explorer, terminal), start before the list.
    local cur = buf_path(vim.api.nvim_get_current_buf())
    local idx = 0
    for i, path in ipairs(list) do
      if path == cur then
        idx = i
        break
      end
    end
    cycle = { list = list, idx = idx }
  end
  local n = #cycle.list
  -- From a special buffer (idx 0), <C-k> goes to the last file of the list
  local idx = (cycle.idx == 0 and step < 0) and 1 or cycle.idx
  -- Wrap around. Skip files that are not usable now.
  for _ = 1, n do
    idx = (idx + step - 1) % n + 1
    if usable(cycle.list[idx]) then
      break
    end
  end
  if n == 0 or not usable(cycle.list[idx]) then
    return
  end
  cycle.idx = idx
  open(cycle.list[idx])
end

vim.keymap.set('n', '<C-j>', function()
  go(1)
end, { desc = 'Previous buffer (recency)' })
vim.keymap.set('n', '<C-k>', function()
  go(-1)
end, { desc = 'Next buffer (recency)' })

vim.keymap.set('n', '<C-h>', function()
  local buf = vim.api.nvim_get_current_buf()
  local path = buf_path(buf)
  if not path then
    return
  end
  local name = vim.fn.fnamemodify(path, ':t')
  if remove(pinned, path) then
    vim.notify('Unpinned: ' .. name)
  else
    table.insert(pinned, path)
    vim.notify('Pinned: ' .. name)
  end
  mark(buf)
  -- Show or hide the pin mark in the winbar (lua/config/options.lua)
  vim.cmd 'redrawstatus!'
end, { desc = 'Pin or unpin buffer in the recency list' })

vim.keymap.set('n', '<C-l>', function()
  local buf = vim.api.nvim_get_current_buf()
  local path = buf_path(buf)
  if path then
    remove(mru, path)
    remove(pinned, path)
  end
  mark(buf)
  for _, p in ipairs(mru) do
    if p ~= path and usable(p) then
      open(p)
      return
    end
  end
  vim.notify('bufcycle: no other file in the list', vim.log.levels.WARN)
end, { desc = 'Remove buffer from the recency list' })

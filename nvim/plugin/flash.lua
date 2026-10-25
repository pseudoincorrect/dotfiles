-- Quick navigation with flash.nvim
local gh = function(r)
  return 'https://github.com/' .. r
end

vim.pack.add { gh 'folke/flash.nvim' }

require('flash').setup {}

vim.keymap.set({ 'n', 'x', 'o' }, 'S', function()
  require('flash').jump()
end, { desc = 'Flash search' })

-- Make labels stand out (re-applied after every colorscheme change)
local function set_label_hl()
  vim.api.nvim_set_hl(0, 'FlashLabel', { fg = '#ffffff', bg = '#ff007c', bold = true })
  vim.api.nvim_set_hl(0, 'WordHintLabel', { fg = '#000000', bg = '#ffd75f', bold = true })
  vim.api.nvim_set_hl(0, 'WordHintPending', { fg = '#ffffff', bg = '#ff007c', bold = true })
end
set_label_hl()
vim.api.nvim_create_autocmd('ColorScheme', { callback = set_label_hl })

-- Label every word of 2+ chars on screen (1 or 2 key labels), then type the label to jump
local hint_ns = vim.api.nvim_create_namespace 'word_hint'
local hint_keys = 'asdfghjklqwertyuiopzxcvbnm'
local word_re = vim.regex [[\<\k\k\+]]

local function hint_labels(n)
  local out = {}
  if n <= #hint_keys then
    for i = 1, n do
      out[i] = hint_keys:sub(i, i)
    end
    return out
  end
  for i = 1, #hint_keys do
    for j = 1, #hint_keys do
      out[#out + 1] = hint_keys:sub(i, i) .. hint_keys:sub(j, j)
      if #out == n then
        return out
      end
    end
  end
  return out
end

local function hint_words()
  local buf = vim.api.nvim_get_current_buf()
  local targets = {}
  local lnum = vim.fn.line 'w0'
  local bottom = vim.fn.line 'w$'
  while lnum <= bottom do
    local fold_end = vim.fn.foldclosedend(lnum)
    if fold_end ~= -1 then
      lnum = fold_end + 1
    else
      local col = 0
      while true do
        local s, e = word_re:match_line(buf, lnum - 1, col)
        if not s then
          break
        end
        targets[#targets + 1] = { lnum = lnum, col = col + s }
        col = col + e
      end
      lnum = lnum + 1
    end
  end
  if #targets == 0 then
    return
  end

  -- Closest words to the cursor get the shortest/first labels
  local cur = vim.api.nvim_win_get_cursor(0)
  table.sort(targets, function(a, b)
    return math.abs(a.lnum - cur[1]) * 1000 + math.abs(a.col - cur[2]) < math.abs(b.lnum - cur[1]) * 1000 + math.abs(b.col - cur[2])
  end)
  local labels = hint_labels(#targets)
  for i, t in ipairs(targets) do
    t.label = labels[i]
  end

  local typed = ''
  local chosen
  while not chosen do
    vim.api.nvim_buf_clear_namespace(buf, hint_ns, 0, -1)
    for _, t in ipairs(targets) do
      if vim.startswith(t.label, typed) then
        local rest = t.label:sub(#typed + 1)
        vim.api.nvim_buf_set_extmark(buf, hint_ns, t.lnum - 1, t.col, {
          virt_text = { { rest, #typed > 0 and 'WordHintPending' or 'WordHintLabel' } },
          virt_text_pos = 'overlay',
          hl_mode = 'combine',
        })
      end
    end
    vim.cmd.redraw()
    local ok, ch = pcall(vim.fn.getcharstr)
    if not ok or ch == '\27' then
      break
    end
    typed = typed .. ch
    local matches = vim.tbl_filter(function(t)
      return vim.startswith(t.label, typed)
    end, targets)
    if #matches == 0 then
      break
    elseif #matches == 1 and matches[1].label == typed then
      chosen = matches[1]
    end
  end
  vim.api.nvim_buf_clear_namespace(buf, hint_ns, 0, -1)
  if chosen then
    vim.cmd "normal! m'"
    vim.api.nvim_win_set_cursor(0, { chosen.lnum, chosen.col })
  end
end

vim.keymap.set({ 'n', 'x', 'o' }, 's', hint_words, { desc = 'Jump to word (labels)' })

vim.keymap.set({ 'n', 'x', 'o' }, '<A-s>', function()
  require('flash').treesitter()
end, { desc = 'Flash Treesitter' })

vim.keymap.set('o', 'r', function()
  require('flash').remote()
end, { desc = 'Remote Flash' })

vim.keymap.set({ 'o', 'x' }, '<C-v>', function()
  require('flash').treesitter_search()
end, { desc = 'Treesitter Search' })

vim.keymap.set('n', 'gS', function()
  require('flash').jump {
    action = function(match, state)
      state:hide()
      vim.api.nvim_set_current_win(match.win)
      vim.api.nvim_win_set_cursor(match.win, match.pos)
      vim.lsp.buf.definition()
    end,
  }
end, { desc = 'Flash Go to Definition' })

-- Multiple cursors
-- https://github.com/jake-stewart/multicursor.nvim
local gh = function(r)
  return 'https://github.com/' .. r
end

vim.pack.add { { src = gh 'jake-stewart/multicursor.nvim', version = '1.0' } }

local mc = require 'multicursor-nvim'
mc.setup()

local set = vim.keymap.set

-- Add / skip cursors by matching the word under cursor (or the visual selection)
set({ 'n', 'x' }, '<A-n>', function()
  mc.matchAddCursor(1)
end, { desc = 'MC: add next match' })
set({ 'n', 'x' }, '<A-x>', function()
  mc.matchSkipCursor(1)
end, { desc = 'MC: skip to next match' })
set({ 'n', 'x' }, '<A-a>', mc.matchAllAddCursors, { desc = 'MC: add all matches' })

-- Add cursors on adjacent lines
set({ 'n', 'x' }, '<A-j>', function()
  mc.lineAddCursor(1)
end, { desc = 'MC: add cursor below' })
set({ 'n', 'x' }, '<A-k>', function()
  mc.lineAddCursor(-1)
end, { desc = 'MC: add cursor above' })

-- Toggle a cursor under the current position, or with the mouse
set({ 'n', 'x' }, '<A-q>', mc.toggleCursor, { desc = 'MC: toggle cursor' })
set('n', '<A-LeftMouse>', mc.handleMouse, { desc = 'MC: toggle cursor (mouse)' })

-- Visual selection -> one cursor per line
set('x', '<A-i>', mc.visualToCursors, { desc = 'MC: cursor per selected line' })

-- Keys only active while multiple cursors exist
mc.addKeymapLayer(function(layer_set)
  layer_set({ 'n', 'x' }, '<A-h>', mc.prevCursor, { desc = 'MC: previous cursor' })
  layer_set({ 'n', 'x' }, '<A-l>', mc.nextCursor, { desc = 'MC: next cursor' })
  layer_set({ 'n', 'x' }, '<A-d>', mc.deleteCursor, { desc = 'MC: delete cursor' })
  layer_set('n', '<esc>', function()
    if not mc.cursorsEnabled() then
      mc.enableCursors()
    else
      mc.clearCursors()
    end
  end, { desc = 'MC: clear cursors' })
end)

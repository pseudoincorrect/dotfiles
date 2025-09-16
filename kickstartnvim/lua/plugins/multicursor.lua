return {
  'jake-stewart/multicursor.nvim',
  event = 'VeryLazy',
  config = function()
    local mc = require 'multicursor-nvim'
    mc.setup()

    vim.keymap.set({ 'n', 'v' }, '<C-a>', function()
      mc.addCursor '*'
    end)
    vim.keymap.set({ 'n', 'v' }, '<C-S-a>', function()
      mc.addCursor()
    end)
    vim.keymap.set({ 'n', 'v' }, "<C-'>", function()
      mc.addCursor 'j'
    end)
    vim.keymap.set({ 'n', 'v' }, '<Esc>', function()
      if not mc.cursorsEnabled() then
        mc.enableCursors()
      elseif mc.hasCursors() then
        mc.clearCursors()
      else
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Esc>', true, false, true), 'n', false)
      end
    end)
  end,
}

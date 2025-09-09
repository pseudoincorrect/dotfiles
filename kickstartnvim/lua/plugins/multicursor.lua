return {
  'jake-stewart/multicursor.nvim',
  lazy = false,
  config = function()
    local mc = require 'multicursor-nvim'
    mc.setup()

    vim.keymap.set({ 'n', 'v' }, '<C-d>', function()
      mc.addCursor '*'
    end)
    vim.keymap.set({ 'n', 'v' }, '<C-u>', function()
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

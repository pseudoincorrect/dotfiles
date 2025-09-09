return {
  'github/copilot.vim',
  lazy = false,
  config = function()
    -- Enable Copilot for specific filetypes
    vim.g.copilot_filetypes = {
      ['*'] = true,
    }

    -- Copilot key mappings
    -- Accept suggestion with Tab (if no completion menu is open)
    vim.keymap.set('i', '<Tab>', function()
      if vim.fn.pumvisible() ~= 0 then
        return '<Tab>'
      else
        return vim.fn['copilot#Accept'] '<Tab>'
      end
    end, { expr = true, replace_keycodes = false })

    -- Navigate suggestions (using different keys since C-l/C-h don't work)
    vim.keymap.set('i', '<C-j>', '<Plug>(copilot-next)', { desc = 'Copilot next suggestion' })
    vim.keymap.set('i', '<C-k>', '<Plug>(copilot-previous)', { desc = 'Copilot previous suggestion' })
    vim.keymap.set('i', '<C-e>', '<Plug>(copilot-suggest)', { desc = 'Copilot suggest' })
    vim.keymap.set('i', '<C-d>', '<Plug>(copilot-dismiss)', { desc = 'Copilot dismiss' })

    -- Toggle Copilot ON/OFF
    vim.keymap.set('n', '<leader>co', ':Copilot enable<CR>', { desc = 'Copilot ON', silent = true })
    vim.keymap.set('n', '<leader>cf', ':Copilot disable<CR>', { desc = 'Copilot OFF', silent = true })
  end,
}

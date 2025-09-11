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

    -- Accept suggestion with Ctrl+m
    vim.keymap.set('i', '<C-.>', function()
      return vim.fn['copilot#Accept'] '<C-m>'
    end, { expr = true, replace_keycodes = false, desc = 'Copilot accept suggestion' })

    -- Navigate suggestions (using different keys since C-l/C-h don't work)
    vim.keymap.set('i', '<C-j>', '<Plug>(copilot-next)', { desc = 'Copilot next suggestion' })
    vim.keymap.set('i', '<C-k>', '<Plug>(copilot-previous)', { desc = 'Copilot previous suggestion' })
    vim.keymap.set('i', '<C-e>', '<Plug>(copilot-suggest)', { desc = 'Copilot suggest' })
    vim.keymap.set('i', '<C-d>', '<Plug>(copilot-dismiss)', { desc = 'Copilot dismiss' })

    -- Toggle Copilot ON/OFF
    vim.keymap.set('n', '<leader>co', ':Copilot enable<CR>', { desc = 'Copilot Enable', silent = true })
    vim.keymap.set('n', '<leader>cu', ':Copilot disable<CR>', { desc = 'Copilot Disable', silent = true })
  end,
}

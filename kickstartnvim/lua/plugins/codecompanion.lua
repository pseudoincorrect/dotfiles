-- CodeCompanion - AI coding assistant
return {
  'olimorris/codecompanion.nvim',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-treesitter/nvim-treesitter',
    'hrsh7th/nvim-cmp', -- Optional: For using slash commands and variables in the chat buffer
    'nvim-telescope/telescope.nvim', -- Optional: For using slash commands
    { 'stevearc/dressing.nvim', opts = {} }, -- Optional: Improves `vim.ui.select`
  },
  config = function()
    require('codecompanion').setup {
      strategies = {
        chat = {
          adapter = 'anthropic',
        },
        inline = {
          adapter = 'anthropic',
        },
        agent = {
          adapter = 'anthropic',
        },
      },
      adapters = {
        anthropic = function()
          return require('codecompanion.adapters').extend('anthropic', {
            env = {
              api_key = 'ANTHROPIC_AUTH_TOKEN',
              url = 'ANTHROPIC_BASE_URL',
            },
          })
        end,
      },
    }
  end,
  keys = {
    { '<leader>ai', '<cmd>CodeCompanionActions<cr>', desc = '[A][I] CodeCompanion Actions', mode = { 'n', 'v' } },
    { '<leader>ac', '<cmd>CodeCompanionChat Toggle<cr>', desc = '[A]I [C]hat Toggle', mode = { 'n', 'v' } },
    { '<leader>aa', '<cmd>CodeCompanionAdd<cr>', desc = '[A]I [A]dd to Chat', mode = 'v' },
    { '<leader>ae', '<cmd>CodeCompanionExplain<cr>', desc = '[A]I [E]xplain Code', mode = 'v' },
    { '<leader>ar', '<cmd>CodeCompanionReview<cr>', desc = '[A]I [R]eview Code', mode = 'v' },
    { '<leader>at', '<cmd>CodeCompanionTest<cr>', desc = '[A]I Generate [T]ests', mode = 'v' },
    { '<leader>af', '<cmd>CodeCompanionFix<cr>', desc = '[A]I [F]ix Code', mode = 'v' },
    { '<leader>ao', '<cmd>CodeCompanionOptimize<cr>', desc = '[A]I [O]ptimize Code', mode = 'v' },
  },
}

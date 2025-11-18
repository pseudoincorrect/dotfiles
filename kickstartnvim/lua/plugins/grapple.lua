-- Grapple: persistent file bookmarks
return {
  'cbochs/grapple.nvim',
  opts = {
    scope = 'git', -- also try out "git_branch"
    style = 'basename', -- Show filename with directory hint
    win_opts = {
      width = 80,
      height = 25,
    },
  },
  event = { 'BufReadPost', 'BufNewFile' },
  cmd = 'Grapple',
  keys = {
    { '<leader>m', '<cmd>Grapple toggle<cr>', desc = 'Grapple toggle' },
    { '<leader>g', '<cmd>Grapple toggle_tags<cr>', desc = 'Grapple window' },
    { '<C-g>', '<cmd>Grapple toggle_tags<cr>', desc = 'Grapple window', mode = { 'n', 'i', 't' } },
  },
}

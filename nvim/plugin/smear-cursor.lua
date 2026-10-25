-- Animated cursor trail
-- https://github.com/sphamba/smear-cursor.nvim
local gh = function(r)
  return 'https://github.com/' .. r
end

vim.pack.add { gh 'sphamba/smear-cursor.nvim' }

require('smear_cursor').setup {}

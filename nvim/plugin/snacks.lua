-- Snacks.nvim - Collection of small QoL plugins
local gh = function(r)
  return 'https://github.com/' .. r
end

vim.pack.add {
  gh 'nvim-tree/nvim-web-devicons',
  gh 'folke/snacks.nvim',
}

require('snacks').setup {
  -- Big file performance optimizations - preserve folds
  bigfile = {
    enabled = true,
    notify = true,
    size = 300 * 1024, -- 1.5MB
    setup = function(ctx)
      vim.opt_local.foldmethod = 'indent'
      vim.opt_local.foldenable = true
      vim.opt_local.foldlevelstart = 99
    end,
  },
  -- Indent scope animations
  indent = {
    enabled = true,
    animate = {
      enabled = true,
    },
  },
  -- File explorer sidebar (replaces neo-tree and netrw)
  explorer = {
    enabled = true,
    replace_netrw = true,
  },
  picker = {
    -- Narrow tree guides: 1 column per level instead of 2
    icons = { tree = { vertical = '│', middle = '├', last = '└' } },
    -- Full words for the flags in the picker title
    toggles = { hidden = 'hidden', ignored = 'ignored' },
    -- Bigger picker windows (the snacks default is 0.8 x 0.8)
    layouts = {
      default = { layout = { width = 0.95, height = 0.9 } },
      vertical = { layout = { width = 0.95, height = 0.9 } },
    },
    -- Same keys as the old fzf-lua config
    win = {
      input = {
        keys = {
          -- Close the picker on the first <Esc>, not go to normal mode
          ['<Esc>'] = { 'close', mode = { 'n', 'i' } },
          ['<Tab>'] = { 'list_up', mode = { 'i', 'n' } },
          ['<S-Tab>'] = { 'list_down', mode = { 'i', 'n' } },
          ['<c-a>'] = { '<Home>', mode = 'i', expr = true, desc = 'beginning of line' },
          ['<c-e>'] = { '<End>', mode = 'i', expr = true, desc = 'end of line' },
          ['<a-a>'] = { 'select_all', mode = { 'i', 'n' } },
          ['<c-/>'] = { 'toggle_help_input', mode = { 'i', 'n' } },
          ['<S-Down>'] = { 'preview_scroll_down', mode = { 'i', 'n' } },
          ['<S-Up>'] = { 'preview_scroll_up', mode = { 'i', 'n' } },
        },
      },
    },
    sources = {
      -- Show the picker at once, not after the first `fd` results.
      -- Not global: LSP pickers (gd) would flash open before the auto jump.
      files = { show_delay = 0 },
      buffers = {
        win = { input = { keys = { ['<c-k>'] = { 'bufdelete', mode = { 'n', 'i' } } } } },
      },
      explorer = {
        hidden = true,
        ignored = true,
        exclude = { '.git', '.DS_Store', 'thumbs.db', '.null-ls_*' },
        layout = {
          preset = 'sidebar',
          preview = false,
          layout = {
            position = 'right',
            width = 45,
            min_width = 45,
            -- No winbar: the winbar adds an empty row at the top of the sidebar
            wo = { winbar = '' },
          },
        },
        actions = {
          focus_main = function(picker)
            vim.api.nvim_set_current_win(picker.main)
          end,
          copy_abs_path = function(_, item)
            vim.fn.setreg('+', item.file)
            vim.notify('Copied: ' .. item.file)
          end,
          copy_rel_path = function(_, item)
            local path = vim.fn.fnamemodify(item.file, ':.')
            vim.fn.setreg('+', path)
            vim.notify('Copied: ' .. path)
          end,
        },
        win = {
          -- In the explorer, <Esc> in the input goes back to the file tree
          input = { keys = { ['<Esc>'] = { 'focus_list', mode = { 'n', 'i' } } } },
          list = {
            keys = {
              ['<esc>'] = 'focus_main',
              ['\\'] = 'close',
              ['ga'] = 'copy_abs_path',
              ['gr'] = 'copy_rel_path',
              ['f'] = 'focus_input',
              -- Swap default paste (p) and preview (P)
              ['p'] = 'toggle_preview',
              ['P'] = 'explorer_paste',
            },
          },
        },
      },
    },
  },
}

-- The snacks tree formatter pads closed ancestors with a fixed 2 spaces.
-- Pad with the width of the tree icons, so narrow icons stay aligned.
require('snacks.picker.format').tree = function(item, picker)
  local icons = picker.opts.icons.tree
  local blank = string.rep(' ', vim.api.nvim_strwidth(icons.vertical))
  local indent = {} ---@type string[]
  local node = item
  while node and node.parent do
    local icon
    if node ~= item then
      icon = node.last and blank or icons.vertical
    else
      icon = node.last and icons.last or icons.middle
    end
    table.insert(indent, 1, icon)
    node = node.parent
  end
  return { { table.concat(indent), 'SnacksPickerTree' } }
end

-- Interactive JSON viewer (fx) in a floating terminal
vim.keymap.set('n', '<leader>x', function()
  local file = vim.api.nvim_buf_get_name(0)
  if file == '' then
    vim.notify('fx: buffer has no file', vim.log.levels.WARN)
    return
  end
  if vim.bo.modified then
    vim.cmd 'silent write'
  end
  require('snacks').terminal({ 'fx', file }, {
    win = { position = 'float', border = 'rounded', width = 0.9, height = 0.9 },
  })
end, { desc = 'View file with fx' })

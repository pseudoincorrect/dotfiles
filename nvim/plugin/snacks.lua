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
    setup = function()
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
      -- hidden: also list dotfiles (.zshrc, ...)
      files = { show_delay = 0, hidden = true },
      buffers = {
        win = { input = { keys = { ['<c-k>'] = { 'bufdelete', mode = { 'n', 'i' } } } } },
      },
      explorer = {
        hidden = true,
        ignored = true,
        exclude = { '.git', '.DS_Store', 'thumbs.db', '.null-ls_*' },
        -- Default file format, plus a pin mark and the tag index for files tagged in grapple
        format = function(item, picker)
          local ret = Snacks.picker.format.file(item, picker)
          if item.dir then
            return ret
          end
          local ok, index = pcall(function()
            return require('grapple').name_or_index { path = item.file }
          end)
          if ok and index then
            local pin = vim.g.have_nerd_font and '󰐃' or '[pin]'
            -- Right-aligned, so all the pins are in one column. Insert it first: the
            -- first right_align extmark goes at the right edge, the git status goes before it.
            table.insert(ret, 1, {
              col = 0,
              virt_text = { { pin .. ' ' .. index .. ' ', 'Comment' } },
              virt_text_pos = 'right_align',
              hl_mode = 'combine',
            })
          end
          return ret
        end,
        layout = {
          preset = 'sidebar',
          -- Preview hidden at start; `p` shows it in the main window, not in the small sidebar.
          -- snacks accepts this table (see config/init.lua), but types it as "main"?
          ---@diagnostic disable-next-line: assign-type-mismatch
          preview = { enabled = false, main = true },
          layout = {
            position = 'left',
            -- No winbar: the winbar adds an empty row at the top of the sidebar
            wo = { winbar = '' },
          },
        },
        actions = {
          -- toggle_preview, but first point the preview to the current main window.
          -- snacks keeps the main window id from when the explorer opened.
          -- If that window closed, the default toggle fails with "Invalid window id".
          toggle_preview_main = function(picker)
            picker.preview:update(picker)
            picker:toggle 'preview'
          end,
          -- Close the preview first, so the main window shows its own buffer again
          focus_main = function(picker)
            if not picker.layout:is_hidden 'preview' then
              picker:toggle('preview', { enable = false })
            end
            vim.api.nvim_set_current_win(picker.main)
          end,
          -- Tag or untag the file under the cursor in grapple
          grapple_toggle = function(picker, item)
            if not item or item.dir then
              return
            end
            require('grapple').toggle { path = item.file }
            picker.list.dirty = true
            picker.list:update()
            vim.cmd 'redrawstatus!'
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
              ['ya'] = { 'copy_abs_path', desc = 'Copy absolute path' },
              ['yr'] = { 'copy_rel_path', desc = 'Copy relative path' },
              ['yy'] = { 'explorer_yank', desc = 'Yank file' },
              ['<C-h>'] = { 'grapple_toggle', desc = 'Grapple toggle' },
              ['y'] = false,
              ['f'] = 'focus_input',
              -- Swap default paste (p) and preview (P)
              ['p'] = 'toggle_preview_main',
              ['P'] = 'explorer_paste',
            },
          },
        },
      },
    },
  },
}

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

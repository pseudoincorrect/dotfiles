-- Neo-tree is a Neovim plugin to browse the file system
-- https://github.com/nvim-neo-tree/neo-tree.nvim

return {
  'nvim-neo-tree/neo-tree.nvim',
  version = '*',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons', -- not strictly required, but recommended
    'MunifTanjim/nui.nvim',
  },
  cmd = 'Neotree',
  opts = {
    sources = { 'filesystem', 'buffers', 'git_status' },
    open_files_do_not_replace_types = { 'terminal', 'Trouble', 'trouble', 'qf', 'Outline' },
    close_if_last_window = false,
    popup_border_style = 'rounded',
    enable_git_status = true,
    enable_diagnostics = true,
    sort_case_insensitive = false,
    default_component_configs = {
      container = {
        enable_character_fade = true
      },
      git_status = {
        symbols = {
          added     = "",
          modified  = "",
          deleted   = "✖",
          renamed   = "󰁕",
          untracked = "",
          ignored   = "",
          unstaged  = "󰄱",
          staged    = "",
          conflict  = "",
        }
      },
    },
    window = {
      position = "left",
      width = 40,
      mapping_options = {
        noremap = true,
        nowait = true,
      },
    },
    filesystem = {
      bind_to_cwd = false,
      follow_current_file = { 
        enabled = true,
        leave_dirs_open = false,
      },
      use_libuv_file_watcher = false,
      filtered_items = {
        visible = false,
        hide_dotfiles = true,
        hide_gitignored = true,
        hide_hidden = true,
        hide_by_name = {
          ".DS_Store",
          "thumbs.db"
        },
        hide_by_pattern = {
          "*.meta",
          "*/src/*/tsconfig.json",
        },
        always_show = {
          ".gitignored"
        },
        never_show = {
          ".DS_Store",
          "thumbs.db"
        },
        never_show_by_pattern = {
          ".null-ls_*",
        },
      },
      window = {
        mappings = {
          ['\\'] = 'close_window',
          ["<bs>"] = "navigate_up",
          ["."] = "set_root",
          ["H"] = "toggle_hidden",
          ["/"] = "fuzzy_finder",
          ["D"] = "fuzzy_finder_directory",
          ["#"] = "fuzzy_sorter",
          ["f"] = "filter_on_submit",
          ["<c-x>"] = "clear_filter",
          ["[g"] = "prev_git_modified",
          ["]g"] = "next_git_modified",
          ["i"] = "show_file_details",
          ["o"] = { "show_help", nowait=false, config = { title = "Order by", prefix_key = "o" } },
          ["oc"] = { "order_by_created", nowait = false },
          ["od"] = { "order_by_diagnostics", nowait = false },
          ["og"] = { "order_by_git_status", nowait = false },
          ["om"] = { "order_by_modified", nowait = false },
          ["on"] = { "order_by_name", nowait = false },
          ["os"] = { "order_by_size", nowait = false },
          ["ot"] = { "order_by_type", nowait = false },
        },
      },
    },
  },
}

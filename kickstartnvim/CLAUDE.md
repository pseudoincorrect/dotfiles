# kickstartnvim File Structure

A modularized Neovim configuration using the built-in `vim.pack` package manager (Neovim 0.12+).

## Root Directory
```
.
├── .gitignore                     # Git ignore patterns for Neovim cache files and temporary data
├── .stylua.toml                   # Lua code formatter configuration for consistent styling
├── LICENSE.md                     # MIT license for the project
├── README.md                      # Installation instructions and documentation
├── Taskfile.yaml                  # Task runner configuration for development workflows
├── doc/
│   ├── kickstart.txt             # Core kickstart.nvim documentation and help file
│   └── tags                      # Vim help tags index for documentation navigation
├── init.lua                      # Main entry point - leader keys, vim.loader, config modules, PackChanged hooks
├── lua/
│   └── config/
│       ├── autocmds.lua         # Vim autocommands for automatic behaviors and file type handling
│       ├── keymaps.lua          # Global key mappings and shortcuts configuration
│       └── options.lua          # Vim options and settings (line numbers, indentation, etc.)
├── plugin/
│   ├── cmp.lua                  # nvim-cmp completion engine configuration and sources
│   ├── conform.lua              # Code formatting with conform.nvim
│   ├── flash.lua                # Quick navigation and jumping within buffers
│   ├── fzf.lua                  # Fuzzy finder for files, buffers, and project-wide search
│   ├── grapple.lua              # Persistent file bookmarks
│   ├── lint.lua                 # Code linting configuration for various file types
│   ├── lsp.lua                  # Language Server Protocol setup and server configurations
│   ├── mini.lua                 # Mini.nvim plugin suite for various utilities
│   ├── misc.lua                 # Small standalone plugins (sleuth, treesitter, session, etc.)
│   ├── neo-tree.lua             # File explorer tree view configuration
│   ├── snacks.lua               # Snacks.nvim QoL plugins (bigfile, indent)
│   ├── themes.lua               # Color scheme and UI theme configurations
│   ├── treesitter.lua           # Treesitter syntax highlighting and code navigation
│   ├── which-key.lua            # Key binding helper and documentation popup
│   └── windsurf.lua             # Codeium AI code assistance integration
└── nvim-pack-lock.json           # vim.pack lockfile for reproducible builds (auto-generated)
```

## Architecture

This configuration follows a modular approach using Neovim's built-in `vim.pack` package manager:
- `init.lua` sets leader keys, enables `vim.loader`, loads config modules, and defines `PackChanged` hooks
- `lua/config/` contains core Neovim configuration (options, keymaps, autocommands)
- `plugin/` contains individual plugin configurations auto-sourced alphabetically after init.lua
- Each `plugin/*.lua` file calls `vim.pack.add()` for its plugins and configures them

Each plugin configuration is self-contained in its own file, making the setup maintainable and easy to customize.
- Always run `task format` at the end of a claude task to format all files.

# kickstartnvim File Structure

A modularized Neovim configuration based on kickstart.nvim with organized plugin management and custom configurations.

## Root Directory
```
.
├── .gitignore                     # Git ignore patterns for Neovim cache files and temporary data
├── .stylua.toml                   # Lua code formatter configuration for consistent styling
├── LICENSE.md                     # MIT license for the project
├── README.md                      # Installation instructions and documentation for kickstart.nvim
├── Taskfile.yaml                  # Task runner configuration for development workflows
├── doc/
│   ├── kickstart.txt             # Core kickstart.nvim documentation and help file
│   └── tags                      # Vim help tags index for documentation navigation
├── init.lua                      # Main entry point - loads config modules and sets up lazy.nvim
├── lazy-lock.json                # Lazy.nvim plugin lockfile for reproducible builds
├── lua/
│   ├── config/
│   │   ├── autocmds.lua         # Vim autocommands for automatic behaviors and file type handling
│   │   ├── keymaps.lua          # Global key mappings and shortcuts configuration
│   │   └── options.lua          # Vim options and settings (line numbers, indentation, etc.)
│   ├── kickstart/
│   │   └── health.lua           # Health check functions for diagnosing configuration issues
│   └── plugins/
│       ├── cmp.lua              # nvim-cmp completion engine configuration and sources
│       ├── copilot.lua          # GitHub Copilot AI code assistance integration
│       ├── flash.lua            # Quick navigation and jumping within buffers
│       ├── lint.lua             # Code linting configuration for various file types
│       ├── lsp.lua              # Language Server Protocol setup and server configurations
│       ├── mini.lua             # Mini.nvim plugin suite for various utilities
│       ├── multicursor.lua      # Multiple cursor editing functionality
│       ├── neo-tree.lua         # File explorer tree view configuration
│       ├── telescope.lua        # Fuzzy finder for files, buffers, and project-wide search
│       ├── themes.lua           # Color scheme and UI theme configurations
│       └── which-key.lua        # Key binding helper and documentation popup
└── nvim -> /home/mclement/git/dotfiles/kickstartnvim/  # Symlink to self for linking config
```

## Architecture

This configuration follows a modular approach where:
- `init.lua` serves as the main entry point and plugin loader
- `lua/config/` contains core Neovim configuration (options, keymaps, autocommands)
- `lua/plugins/` contains individual plugin configurations as separate modules
- `lua/kickstart/` contains kickstart.nvim specific utilities and health checks

Each plugin configuration is self-contained in its own file, making the setup maintainable and easy to customize.
- Always run `task format` at the end of a claude task to format all files.
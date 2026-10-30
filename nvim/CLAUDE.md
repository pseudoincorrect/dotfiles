# kickstartnvim

Uses Neovim's built-in `vim.pack` package manager (Neovim 0.12+), not lazy.nvim: each `plugin/*.lua` calls `vim.pack.add()` for its plugins and configures them; `init.lua` defines the `PackChanged` hooks.

- Always run `task format` at the end of a claude task to format all files.

-- LSP Configuration
local gh = function(r)
  return 'https://github.com/' .. r
end

vim.pack.add {
  gh 'j-hui/fidget.nvim',
  gh 'williamboman/mason.nvim',
  gh 'williamboman/mason-lspconfig.nvim',
  gh 'WhoIsSethDaniel/mason-tool-installer.nvim',
  gh 'neovim/nvim-lspconfig',
}

require('fidget').setup {}

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
  callback = function(event)
    local map = function(keys, func, desc, mode)
      mode = mode or 'n'
      vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = desc })
    end

    -- Show only classes, functions and methods in the symbol pickers
    local kinds = { 'Class', 'Function', 'Method' }
    local symbol_filter = { default = kinds, lua = kinds }

    map('gd', function()
      Snacks.picker.lsp_definitions()
    end, 'Goto Definition')
    map('gr', function()
      Snacks.picker.lsp_references()
    end, 'Goto References')
    map('gi', function()
      Snacks.picker.lsp_implementations()
    end, 'Goto Implementation')
    map('gt', function()
      Snacks.picker.lsp_type_definitions()
    end, 'Goto Type definition')
    map('<leader>s', function()
      Snacks.picker.lsp_symbols { filter = symbol_filter }
    end, 'Symbols')
    map('<leader>sS', function()
      Snacks.picker.lsp_workspace_symbols { filter = symbol_filter }
    end, 'Symbol Wspace')

    map('<leader>cr', vim.lsp.buf.rename, 'Rename')
    map('<leader>ca', vim.lsp.buf.code_action, 'Code Action', { 'n', 'x' })
    map('<leader>cf', vim.lsp.buf.format, 'Format Document')
    map('<leader>cd', vim.diagnostic.open_float, 'Show Problem')
    map('<leader>cp', function()
      local diagnostics = vim.diagnostic.get(0, { lnum = vim.fn.line '.' - 1 })
      if #diagnostics > 0 then
        vim.fn.setreg('+', diagnostics[1].message)
        vim.notify 'Diagnostic copied to clipboard'
      else
        vim.notify 'No diagnostic at cursor'
      end
    end, 'Copy Diagnostic')
    map('gD', vim.lsp.buf.declaration, 'Goto Declaration')

    local client = vim.lsp.get_client_by_id(event.data.client_id)
    if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
      local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
      vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
        buffer = event.buf,
        group = highlight_augroup,
        callback = vim.lsp.buf.document_highlight,
      })

      vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
        buffer = event.buf,
        group = highlight_augroup,
        callback = vim.lsp.buf.clear_references,
      })

      vim.api.nvim_create_autocmd('LspDetach', {
        group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
        callback = function(event2)
          vim.lsp.buf.clear_references()
          vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
        end,
      })
    end

    if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
      map('<leader>ci', function()
        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
      end, 'Toggle Inlay Hints')
    end
  end,
})

-- Change diagnostic symbols in the sign column (gutter)
local signs = { Error = '', Warn = '', Hint = '', Info = '' }
for type, icon in pairs(signs) do
  local hl = 'DiagnosticSign' .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

-- Extend LSP capabilities with nvim-cmp for better completion support
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())

-- LSP servers configuration
local servers = {
  clangd = {},
  gopls = {},
  pyright = {},
  rust_analyzer = {},

  lua_ls = {
    -- Plugins in plugin/*.lua after this file are not yet on the runtimepath here.
    -- Read the runtimepath when the server starts, after all plugins are loaded.
    on_init = function(client)
      local lua = client.config.settings.Lua --[[@as table]]
      lua.workspace.library = vim.list_extend({ '${3rd}/luv/library' }, vim.api.nvim_get_runtime_file('', true))
    end,
    settings = {
      Lua = {
        runtime = { version = 'LuaJIT' },
        workspace = { checkThirdParty = false },
        completion = {
          callSnippet = 'Replace',
        },
        diagnostics = {
          disable = { 'missing-fields' },
        },
      },
    },
  },
}

require('mason').setup()

local ensure_installed = vim.tbl_keys(servers or {})
vim.list_extend(ensure_installed, {
  'stylua',
})
require('mason-tool-installer').setup { ensure_installed = ensure_installed }

-- mason-lspconfig v2 ignores `handlers`: register the configs with vim.lsp.config,
-- then mason-lspconfig enables the installed servers (automatic_enable).
for name, server in pairs(servers) do
  server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
  vim.lsp.config(name, server)
end

require('mason-lspconfig').setup {}

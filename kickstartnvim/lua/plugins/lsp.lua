-- LSP Configuration
return {
  'neovim/nvim-lspconfig',
  dependencies = {
    { 'williamboman/mason.nvim', config = true },
    'williamboman/mason-lspconfig.nvim',
    'WhoIsSethDaniel/mason-tool-installer.nvim',
    { 'j-hui/fidget.nvim', opts = {} },
    'hrsh7th/cmp-nvim-lsp',
  },
  config = function()
    vim.api.nvim_create_autocmd('LspAttach', {
      group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
      callback = function(event)
        local map = function(keys, func, desc, mode)
          mode = mode or 'n'
          vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = desc })
        end

        map('gd', function()
          require('telescope.builtin').lsp_definitions { show_line = false }
        end, 'Goto Definition')

        map('gr', function()
          require('telescope.builtin').lsp_references { show_line = false }
        end, 'Goto References')

        map('gi', function()
          require('telescope.builtin').lsp_implementations { show_line = false }
        end, 'Goto Implementation')

        map('gt', function()
          require('telescope.builtin').lsp_type_definitions { show_line = false }
        end, 'Goto Type definition')

        map('<leader>l', function()
          require('telescope.builtin').lsp_document_symbols {
            show_line = false,
            symbols = { 'Function', 'Method', 'Class' },
            fname_width = 0.3,
            symbol_width = 0.7,
            symbol_type_width = 12,
          }
        end, 'Symbols')

        map('<leader>sS', function()
          require('telescope.builtin').lsp_dynamic_workspace_symbols { show_line = false }
        end, 'Symbol Workspace')

        map('<leader>cr', vim.lsp.buf.rename, 'Rename')
        map('<leader>ca', vim.lsp.buf.code_action, 'Code Action', { 'n', 'x' })
        map('<leader>cf', vim.lsp.buf.format, 'Format Document')
        map('gD', vim.lsp.buf.declaration, 'Goto Declaration')

        local client = vim.lsp.get_client_by_id(event.data.client_id)
        if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
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

        if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
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

    -- LSP servers and clients are able to communicate to each other what features they support.
    -- Extend LSP capabilities with nvim-cmp for better completion support.
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())

    -- Enable the following language servers
    -- Add/remove LSPs below. See :help lspconfig-all for available servers. Override settings as needed.
    local servers = {
      clangd = {},
      gopls = {},
      pyright = {},
      rust_analyzer = {},
      -- ... See :help lspconfig-all for more servers. For TypeScript, consider typescript-tools.nvim or ts_ls.

      lua_ls = {
        -- cmd = {...},
        -- filetypes = { ...},
        -- capabilities = {},
        settings = {
          Lua = {
            completion = {
              callSnippet = 'Replace',
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

    require('mason-lspconfig').setup {
      handlers = {
        function(server_name)
          local server = servers[server_name] or {}
          server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
          require('lspconfig')[server_name].setup(server)
        end,
      },
    }
  end,
}

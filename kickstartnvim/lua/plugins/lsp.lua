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

        map('gd', require('fzf-lua').lsp_definitions, 'Goto Definition')
        map('gr', require('fzf-lua').lsp_references, 'Goto References')
        map('gi', require('fzf-lua').lsp_implementations, 'Goto Implementation')
        map('gt', require('fzf-lua').lsp_typedefs, 'Goto Type definition')
        map('<leader>ss', function()
          require('fzf-lua').lsp_document_symbols {
            regex_filter = function(entry)
              return entry.kind == 'Class' or entry.kind == 'Function' or entry.kind == 'Method'
            end,
          }
        end, 'Symbols')
        map('<leader>sS', function()
          require('fzf-lua').lsp_workspace_symbols {
            regex_filter = function(entry)
              return entry.kind == 'Class' or entry.kind == 'Function' or entry.kind == 'Method'
            end,
          }
        end, 'Symbol Wspace')

        map('<leader>cr', vim.lsp.buf.rename, 'Rename')
        map('<leader>ca', require('fzf-lua').lsp_code_actions, 'Code Action', { 'n', 'x' })
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

-- -------------------------------------
-- Suggested configuration
-- ref. https://github.com/neovim/nvim-lspconfig#suggested-configuration
-- -------------------------------------
-- Global mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float)
vim.keymap.set('n', '[d', function() vim.diagnostic.jump({ count = -1 }) end)
vim.keymap.set('n', ']d', function() vim.diagnostic.jump({ count = 1 }) end)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist)

-- Use LspAttach autocommand to only map the following keys
-- after the language server attaches to the current buffer
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    -- Enable completion triggered by <c-x><c-o>
    vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

    -- Buffer local mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local opts = { buffer = ev.buf }
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
    vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
    vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)
    vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
    vim.keymap.set('n', '<space>wl', function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, opts)
    vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts)

    -- Run rename and code_action via Lspsaga.
    --
    -- vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)
    -- vim.keymap.set({ 'n', 'v' }, '<space>ca', vim.lsp.buf.code_action, opts)
    vim.keymap.set('n', '<space>rn', '<cmd>Lspsaga rename<CR>', opts)
    vim.keymap.set({ 'n', 'v' }, '<space>ca', '<cmd>Lspsaga code_action<CR>', opts)

    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
    vim.keymap.set('n', '<space>f', function()
      vim.lsp.buf.format { async = true }
    end, opts)

    -- Show line diagnostics automatically in hover window
    -- ref. https://github.com/neovim/nvim-lspconfig/wiki/UI-customization#show-line-diagnostics-automatically-in-hover-window
    vim.api.nvim_create_autocmd("CursorHold", {
      buffer = ev.buf,
      callback = function()
        local floatopts = {
          focusable = false,
          close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
          source = 'if_many', -- instead of 'always'
          prefix = ' ',
          scope = 'cursor',
        }
        vim.diagnostic.open_float(nil, floatopts)
      end
    })

    -- After an LSP client attaches to a buffer, display LSP client names on lualine.
    -- ref. https://neovim.io/doc/user/lsp.html#lsp-events
    --
    -- NOTE: Instead of retrieving all clients each time, it may be possible to
    -- retrieve only the attached client using vim.lsp.get_client_by_id.
    local client_names = {}
    for _, client in ipairs(vim.lsp.get_clients { bufnr = 0 }) do
      table.insert(client_names, client.name)
    end
    local comma_separated_client_names = table.concat(client_names, ', ')
    local bufnr = ev.buf
    vim.b[bufnr].lsp_mode = 'LSP:'..comma_separated_client_names
  end,
})

vim.diagnostic.config({
  -- Override default (false): sort multiple diagnostics by severity (error > warn > info > hint)
  severity_sort = true,
})

-- -------------------------------------
-- nvim-cmp autocompletion
-- ref. https://github.com/neovim/nvim-lspconfig/wiki/Autocompletion#nvim-cmp
-- -------------------------------------
-- Apply cmp_nvim_lsp capabilities to all LSP servers globally.
-- ref. https://github.com/hrsh7th/cmp-nvim-lsp#setup
vim.lsp.config('*', { capabilities = require('cmp_nvim_lsp').default_capabilities() })

-- GraphQL: restrict to .graphql files only (exclude typescriptreact, javascriptreact)
-- note: requires a graphql config file
-- ref. https://github.com/graphql/graphiql/blob/main/packages/graphql-language-service-server/README.md#graphql-configuration-file
vim.lsp.config('graphql', {
  filetypes = { 'graphql' },
})

-- ref. https://github.com/golang/tools/blob/master/gopls/doc/vim.md#custom-configuration
vim.lsp.config('gopls', {
  settings = {
    gopls = {
      staticcheck = false,
    }
  }
})

vim.lsp.enable('bashls')                          -- bash-language-server
vim.lsp.enable('docker_compose_language_service') -- docker-compose-language-service
vim.lsp.enable('gopls')                           -- gopls
vim.lsp.enable('graphql')                         -- graphql-language-service-cli
vim.lsp.enable('jsonls')                          -- json-lsp
vim.lsp.enable('kotlin_language_server')          -- kotlin-language-server
vim.lsp.enable('prismals')                        -- prisma-language-server
vim.lsp.enable('pyright')                         -- pyright
vim.lsp.enable('terraformls')                     -- terraform-ls
vim.lsp.enable('vimls')                           -- vim-language-server

-- C++
vim.lsp.config('clangd', {
  -- Server-specific settings
  cmd = { 'clangd', '--background-index', '-header-insertion=never' },
  init_options = {
    -- ref. https://clangd.llvm.org/extensions.html#file-status
    clangdFileStatus = true
  },
})
vim.lsp.enable('clangd')

-- TypeScript
vim.lsp.config('tsgo', {
  cmd = { 'tsgo', '--lsp', '--stdio' },
  filetypes = { 'typescript', 'typescriptreact', 'javascript', 'javascriptreact' },
  root_markers = { 'tsconfig.json', 'jsconfig.json', 'package.json', '.git' },
})
vim.lsp.enable('tsgo')

vim.lsp.config('lua_ls', {
  settings = {
    Lua = {
      telemetry = {
        enable = false,
      },
      diagnostics = {
        disable = { 'missing-fields' },
        globals = { 'vim' },
      },
    }
  }
})
vim.lsp.enable('lua_ls')

-- Yaml
-- Suppress diagnostic code 513 (PropertyExpected, 0x201 in vscode-json-languageservice),
-- which is a false positive triggered by the "config" property in certain YAML files.
vim.lsp.config('yamlls', {
  on_attach = function(_, _)
    local original_handler = vim.lsp.handlers["textDocument/publishDiagnostics"]
    vim.lsp.handlers["textDocument/publishDiagnostics"] = function(err, result, ctx, config)
      if result and result.diagnostics then
        result.diagnostics = vim.tbl_filter(function(diagnostic)
          return diagnostic.code ~= 513
        end, result.diagnostics)
      end
      original_handler(err, result, ctx, config)
    end
  end,
})
vim.lsp.enable('yamlls')

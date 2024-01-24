local ok, lspconfig = pcall(require, 'lspconfig')
if not ok then
  print('nvim-lspconfig is not loaded.')
  return
end

-- -------------------------------------
-- Suggested configuration
-- ref. https://github.com/neovim/nvim-lspconfig#suggested-configuration
-- -------------------------------------
-- Global mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
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

    -- If typescript-tools' go to source definition command can be used, give priority to it.
    -- 2: full match with a command
    --
    -- vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    if vim.fn.exists(":TSToolsGoToSourceDefinition") == 2 then
      vim.keymap.set('n', 'gd', '<cmd>TSToolsGoToSourceDefinition<CR>', opts)
    else
      vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    end

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
          border = 'single',  -- instead of 'rounded'
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
    for _, client in ipairs(vim.lsp.get_active_clients { bufnr = 0 }) do
      table.insert(client_names, client.name)
    end
    local comma_separated_client_names = table.concat(client_names, ', ')
    local bufnr = ev.buf
    vim.b[bufnr].lsp_mode = 'LSP:'..comma_separated_client_names
  end,
})

-- Override handler's config.
-- ref. https://neovim.io/doc/user/lsp.html#lsp-handlers
vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
  vim.lsp.handlers.hover,
  {
    -- Use a sharp border with `FloatBorder` highlights
    border = "single"
  }
)

vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics,
  {
    -- Show the list of diagnostics with trouble.nvim plugin
    virtual_text = false
  }
)

-- NOTE: Make sure to set up neodev before lspconfig
-- ref. https://github.com/folke/neodev.nvim?tab=readme-ov-file#-setup
require('neodev').setup()

-- -------------------------------------
-- nvim-cmp autocompletion
-- ref. https://github.com/neovim/nvim-lspconfig/wiki/Autocompletion#nvim-cmp
-- -------------------------------------
-- The nvim-cmp almost supports LSP's capabilities so You should advertise it to LSP servers..
-- ref. https://github.com/hrsh7th/cmp-nvim-lsp#setup
local capabilities = require('cmp_nvim_lsp').default_capabilities()

-- ref. https://github.com/williamboman/mason-lspconfig.nvim?tab=readme-ov-file#setup
require('mason').setup()
require('mason-lspconfig').setup()

local servers = {
  bashls = {},                 -- bash:      (npm) bash-language-server
  gopls = {                    -- go:        (golang) gopls
    -- ref. https://github.com/golang/tools/blob/master/gopls/doc/vim.md#custom-configuration
    gopls = {
      staticcheck = false,
    }
  },
  graphql = {                  -- graphql:   (npm) graphql-language-service-cli
    -- Exclude typescriptreact, javascriptreact
    filetypes = { 'graphql' },
  },
  jsonls = {},                 -- json:      (npm) vscode-langservers-extracted
  kotlin_language_server = {}, -- kotlin:    (github(kotlin)) kotlin-language-server
  lua_ls = {                   -- lua:       (github(lua)) lua-language-server
    Lua = {
      -- ref. https://github.com/LuaLS/lua-language-server/wiki/Privacy#disabling-telemetry
      telemetry = {
        enable = false,
      },
      -- Ignore missing-fields warnings.
      diagnostics = { disable = { 'missing-fields' } },
    }
  },
  prismals = {},               -- prisma:    (npm) @prisma/language-server
  pyright = {},                -- python:    (npm) pyright
  -- NOTE: The ruby-lsp process doesn't end even after neovim ends, and the CPU usage rate becomes 100%.
  -- ruby_ls = {},                -- ruby:      (gem) ruby-lsp
  terraformls = {},            -- terraform: (generic(go)) terraform-ls
  vimls = {},                  -- vim:       (npm) vim-language-server
  yamlls = {},                 -- yaml:      (npm) yaml-language-server
}

-- Ensure the servers above are installed
local mason_lspconfig = require 'mason-lspconfig'

mason_lspconfig.setup {
  ensure_installed = vim.tbl_keys(servers),
}

mason_lspconfig.setup_handlers {
  function(server_name)
    require('lspconfig')[server_name].setup {
      capabilities = capabilities,
      settings = servers[server_name],
      filetypes = (servers[server_name] or {}).filetypes,
    }
  end,
}

-- C++
lspconfig.clangd.setup({
  -- Common settings
  capabilities = capabilities,
  -- Server-specific settings
  cmd = { 'clangd', '--background-index', '-header-insertion=never' },
  init_options = {
    -- ref. https://clangd.llvm.org/extensions.html#file-status
    clangdFileStatus = true
  },
})

-- TypeScript
require("typescript-tools").setup {
  capabilities = capabilities,
  settings = {
    tsserver_file_preferences = {
      includeInlayParameterNameHints = "all",
      includeInlayEnumMemberValueHints = true,
      includeInlayFunctionLikeReturnTypeHints = true,
      includeInlayFunctionParameterTypeHints = true,
      includeInlayPropertyDeclarationTypeHints = true,
      includeInlayVariableTypeHints = true
    },
  }
}

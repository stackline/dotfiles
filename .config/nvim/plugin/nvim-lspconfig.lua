local ok, lspconfig = pcall(require, 'lspconfig')
if not ok then
  print('nvim-lspconfig is not loaded.')
  return
end

-- -------------------------------------
-- Suggested configuration
-- ref. https://github.com/neovim/nvim-lspconfig#suggested-configuration
-- -------------------------------------
-- Mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
local opts = { noremap = true, silent = true }
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, opts)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, opts)

local on_init = function()
  vim.b.lsp_mode = 'LSP'
end

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(_, bufnr)
  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  local bufopts = { noremap = true, silent = true, buffer = bufnr }
  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
  vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
  vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, bufopts)
  vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
  vim.keymap.set('n', '<space>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, bufopts)
  vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, bufopts)
  vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, bufopts)
  vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, bufopts)
  vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
  vim.keymap.set('n', '<space>f', function() vim.lsp.buf.format { async = true } end, bufopts)

  -- Show line diagnostics automatically in hover window
  -- ref. https://github.com/neovim/nvim-lspconfig/wiki/UI-customization#show-line-diagnostics-automatically-in-hover-window
  vim.api.nvim_create_autocmd("CursorHold", {
    buffer = bufnr,
    callback = function()
      local floatopts = {
        focusable = false,
        close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
        border = 'single', -- instead of 'rounded'
        source = 'if_many', -- instead of 'always'
        prefix = ' ',
        scope = 'cursor',
      }
      vim.diagnostic.open_float(nil, floatopts)
    end
  })
end

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

-- Formatting on save
vim.api.nvim_create_autocmd("BufWritePre", {
  callback = function()
    vim.lsp.buf.format({ async = true })
  end,
})

-- -------------------------------------
-- nvim-cmp autocompletion
-- ref. https://github.com/neovim/nvim-lspconfig/wiki/Autocompletion#nvim-cmp
-- -------------------------------------
-- The nvim-cmp almost supports LSP's capabilities so You should advertise it to LSP servers..
-- ref. https://github.com/hrsh7th/cmp-nvim-lsp#setup
local capabilities = require('cmp_nvim_lsp').default_capabilities()

-- Bash
lspconfig.bashls.setup {
  -- Common settings
  on_init = on_init,
  on_attach = on_attach,
  capabilities = capabilities,
  -- Server-specific settings
}

-- C++
lspconfig.clangd.setup({
  -- Common settings
  on_init = on_init,
  on_attach = on_attach,
  capabilities = capabilities,
  -- Server-specific settings
  cmd = { 'clangd', '--background-index', '-header-insertion=never' },
  init_options = {
    -- ref. https://clangd.llvm.org/extensions.html#file-status
    clangdFileStatus = true
  },
})

-- Go
-- ref. https://github.com/golang/tools/blob/master/gopls/doc/vim.md#custom-configuration
lspconfig.gopls.setup {
  -- Common settings
  on_init = on_init,
  on_attach = on_attach,
  capabilities = capabilities,
  -- Server-specific settings
  settings = {
    gopls = {
      staticcheck = false,
    }
  }
}

-- Lua
lspconfig.sumneko_lua.setup {
  -- Common settings
  on_init = on_init,
  on_attach = on_attach,
  capabilities = capabilities,
  -- Server-specific settings
  settings = {
    Lua = {
      diagnostics = {
        -- Prevent the warning "Undefined global vim"
        globals = { 'vim' },
      },
      -- Disable telemetry.
      -- ref. https://github.com/sumneko/lua-language-server/wiki/Privacy-Policy#disabling-telemetry
      telemetry = {
        enable = false,
      },
    }
  }
}

-- Ruby
lspconfig.solargraph.setup {
  -- Common settings
  on_init = on_init,
  on_attach = on_attach,
  capabilities = capabilities,
  -- Server-specific settings
  settings = {
    solargraph = {
      diagnostics = false
    }
  }
}

-- TypeScript
lspconfig.tsserver.setup {
  -- Common settings
  on_init = on_init,
  on_attach = on_attach,
  capabilities = capabilities,
  -- Server-specific settings
}

-- Vim script
lspconfig.vimls.setup {
  -- Common settings
  on_init = on_init,
  on_attach = on_attach,
  capabilities = capabilities,
  -- Server-specific settings
}

-- YAML
lspconfig.yamlls.setup {
  -- Common settings
  on_init = on_init,
  on_attach = on_attach,
  capabilities = capabilities,
  -- Server-specific settings
}

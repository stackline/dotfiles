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
local opts = { noremap=true, silent=true }
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, opts)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, opts)

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  local bufopts = { noremap=true, silent=true, buffer=bufnr }
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
  vim.keymap.set('n', '<space>f', vim.lsp.buf.formatting, bufopts)

  -- Do formatting with ALE, so disable LSP formatting
  client.resolved_capabilities.document_formatting = false
  client.resolved_capabilities.document_range_formatting = false
end

-- -------------------------------------
-- nvim-cmp autocompletion
-- ref. https://github.com/neovim/nvim-lspconfig/wiki/Autocompletion#nvim-cmp
-- -------------------------------------
-- Add additional capabilities supported by nvim-cmp
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)

local lsp_flags = {
  -- This is the default in Nvim 0.7+
  debounce_text_changes = 150,
}

-- Use a loop to conveniently call 'setup' on multiple servers and
-- map buffer local keybindings when the language server attaches
local servers = { 'bashls', 'tsserver', 'vimls', 'yamlls' }
for _, lsp in pairs(servers) do
  lspconfig[lsp].setup {
    on_attach = on_attach,
    -- Enable some language servers with the additional completion capabilities offered by nvim-cmp
    capabilities = capabilities,
    flags = lsp_flags,
  }
end

-- C++
local lsp_status = require('lsp-status')
lspconfig.clangd.setup({
  cmd = { 'clangd', '--background-index', '-header-insertion=never' },
  handlers = lsp_status.extensions.clangd.setup(),
  init_options = {
    -- ref. https://clangd.llvm.org/extensions.html#file-status
    clangdFileStatus = true
  },
  on_attach = lsp_status.on_attach,
  capabilities = lsp_status.capabilities,
  flags = lsp_flags,
})

-- Go
-- ref. https://github.com/golang/tools/blob/master/gopls/doc/vim.md#custom-configuration
lspconfig.gopls.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  flags = lsp_flags,
  settings = {
    gopls = {
      staticcheck = false,
    }
  }
}

-- Lua
lspconfig.sumneko_lua.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  flags = lsp_flags,
  settings = {
    Lua = {
      diagnostics = {
        -- Prevent the warning "Undefined global vim"
        globals = {'vim'},
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
  on_attach = on_attach,
  capabilities = capabilities,
  flags = lsp_flags,
  settings = {
    solargraph = {
      diagnostics = false
    }
  }
}

-- -------------------------------------
-- Custom settings
-- -------------------------------------
-- Print diagnostics to message area
-- ref. https://github.com/neovim/nvim-lspconfig/wiki/UI-customization#print-diagnostics-to-message-area
function PrintDiagnostics(opts, bufnr, line_nr)
  bufnr = bufnr or 0
  line_nr = line_nr or (vim.api.nvim_win_get_cursor(0)[1] - 1)
  opts = opts or {['lnum'] = line_nr}

  local line_diagnostics = vim.diagnostic.get(bufnr, opts)
  if vim.tbl_isempty(line_diagnostics) then return end

  -- Avoid displaying hit-enter prompt.
  -- Display same content as error/warning displayed in virtual text.
  print(line_diagnostics[#line_diagnostics]['message'])
end

vim.cmd [[ autocmd! CursorHold * lua PrintDiagnostics() ]]

-- Change prefix/character preceding the diagnostics' virtual text
-- ref. https://github.com/neovim/nvim-lspconfig/wiki/UI-customization#change-prefixcharacter-preceding-the-diagnostics-virtual-text
vim.diagnostic.config({
  virtual_text = {
    prefix = '-',
  }
})

vim.lsp.handlers["textDocument/publishDiagnostics"] = function() end

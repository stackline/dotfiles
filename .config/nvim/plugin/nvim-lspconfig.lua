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
vim.api.nvim_set_keymap('n', '<space>e', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
vim.api.nvim_set_keymap('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
vim.api.nvim_set_keymap('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
vim.api.nvim_set_keymap('n', '<space>q', '<cmd>lua vim.diagnostic.setloclist()<CR>', opts)

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)

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

-- Use a loop to conveniently call 'setup' on multiple servers and
-- map buffer local keybindings when the language server attaches
local servers = { 'bashls', 'tsserver', 'vimls', 'yamlls' }
for _, lsp in pairs(servers) do
  lspconfig[lsp].setup {
    on_attach = on_attach,
    -- Enable some language servers with the additional completion capabilities offered by nvim-cmp
    capabilities = capabilities,
    flags = {
      -- This will be the default in neovim 0.7+
      debounce_text_changes = 150,
    }
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
  flags = {
    debounce_text_changes = 150,
  },
})

-- Go
-- ref. https://github.com/golang/tools/blob/master/gopls/doc/vim.md#custom-configuration
lspconfig.gopls.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  flags = {
    debounce_text_changes = 150,
  },
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
  flags = {
    debounce_text_changes = 150,
  },
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
  flags = {
    debounce_text_changes = 150,
  },
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

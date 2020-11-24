-- nvim-lspconfig
--   ref. https://github.com/neovim/nvim-lspconfig#usage
-- lsp-status.nvim
--   ref. https://github.com/nvim-lua/lsp-status.nvim#configuration

local lsp_status = require('lsp-status')

lsp_status.register_progress()
-- Do not use iconic fonts as diagnostics symbols.
-- ref. h: lsp-status.config
lsp_status.config({
  current_function = false,
  indicator_errors = 'e',
  indicator_warnings = 'w',
  indicator_info = 'i',
  indicator_hint = 'h',
  indicator_ok = 'ok',
  status_symbol = 'lsp:',
})

local lspconfig = require('lspconfig')

lspconfig.clangd.setup({
  handlers = lsp_status.extensions.clangd.setup(),
  init_options = {
    -- ref. https://clangd.llvm.org/extensions.html#file-status
    clangdFileStatus = true
  },
  on_attach = lsp_status.on_attach,
  capabilities = lsp_status.capabilities
})

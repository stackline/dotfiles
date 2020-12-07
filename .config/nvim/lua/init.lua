-- Uncomment the following when debugging
-- ref. https://neovim.io/doc/user/lsp.html#vim.lsp.set_log_level()
--
-- vim.lsp.set_log_level('debug')

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

-- $ npm install -g bash-language-server
lspconfig.bashls.setup{}
lspconfig.clangd.setup({
  cmd = { 'clangd', '--background-index', '-header-insertion=never' },
  handlers = lsp_status.extensions.clangd.setup(),
  init_options = {
    -- ref. https://clangd.llvm.org/extensions.html#file-status
    clangdFileStatus = true
  },
  on_attach = lsp_status.on_attach,
  capabilities = lsp_status.capabilities
})
lspconfig.gopls.setup{}
lspconfig.sumneko_lua.setup{}
lspconfig.vimls.setup{}

--
-- TODO: Enable underlining where errors are detected.
-- MEMO: How to disable Neovim built-in LSP diagnostics globally
--
-- ```lua
-- vim.lsp.callbacks["textDocument/publishDiagnostics"] = function() end
-- ```
--
local vim_lsp = vim.lsp

vim_lsp.handlers["textDocument/publishDiagnostics"] = vim_lsp.with(
  -- ref. :h vim.lsp.diagnostic.on_publish_diagnostics
  vim_lsp.diagnostic.on_publish_diagnostics, {
    virtual_text = {
      -- NOTE: Default prefix may be an East Asian Width.
      -- It shifts the text when displaying virtual text with default prefix.
      prefix = "-",
    },
  }
)

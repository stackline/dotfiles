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
lspconfig.vimls.setup{}

--
-- TODO: Enable underlining where errors are detected.
-- MEMO: How to disable Neovim built-in LSP diagnostics globally
--
-- ```lua
-- vim.lsp.callbacks["textDocument/publishDiagnostics"] = function() end
-- ```
--
local lsp = vim.lsp
local util = vim.lsp.util
local M = vim.lsp.handlers

M["textDocument/publishDiagnostics"] = lsp.with(
  -- ref. :h vim.lsp.diagnostic.on_publish_diagnostics
  lsp.diagnostic.on_publish_diagnostics, {
    virtual_text = {
      -- NOTE: Default prefix may be an East Asian Width.
      -- It shifts the text when displaying virtual text with default prefix.
      prefix = "-",
    },
  }
)

--
-- NOTE: Do not display blank line separator in a popup window.
--
-- Neovim built-in LSP uses Box-drawing character (Unicode U+2500) as blank line separator.
-- Box-drawing characters have the characteristic of being *ambiguous*.
-- Do not display blank line separator because the indent is off.
--
--   Ref. blank line separator inserting
--   https://github.com/neovim/neovim/blob/1e5913483469528c7e8d1f927b28c0185eb94941/runtime/lua/vim/lsp/util.lua#L852-L864
--
-- Copy the built-in implementation and add the "separator = false" option.
--
--   Ref. textDocument/hover handler
--   https://github.com/neovim/neovim/blob/1e5913483469528c7e8d1f927b28c0185eb94941/runtime/lua/vim/lsp/handlers.lua#L179-L197
--
M['textDocument/hover'] = function(_, method, result)
  util.focusable_float(method, function()
    if not (result and result.contents) then
      -- return { 'No information available' }
      return
    end
    local markdown_lines = util.convert_input_to_markdown_lines(result.contents)
    markdown_lines = util.trim_empty_lines(markdown_lines)
    if vim.tbl_isempty(markdown_lines) then
      -- return { 'No information available' }
      return
    end
    local bufnr, winnr = util.fancy_floating_markdown(markdown_lines, {
      pad_left = 1; pad_right = 1;
      separator = false;
    })
    util.close_preview_autocmd({"CursorMoved", "BufHidden", "InsertCharPre"}, winnr)
    return bufnr, winnr
  end)
end

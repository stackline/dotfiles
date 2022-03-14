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

-- Keybindings and completion
-- ref. https://github.com/neovim/nvim-lspconfig#keybindings-and-completion
local nvim_lsp = require('lspconfig')

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  -- Enable completion triggered by <c-x><c-o>
  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  local opts = { noremap=true, silent=true }

  -- See `:help vim.lsp.*` for documentation on any of the below functions
  buf_set_keymap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  buf_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  buf_set_keymap('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  buf_set_keymap('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  buf_set_keymap('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  buf_set_keymap('n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  buf_set_keymap('n', '<space>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
  buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
  buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
  buf_set_keymap('n', '<space>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
  buf_set_keymap('n', '<space>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)
end

-- cmp-nvim-lsp setup
-- ref. https://github.com/hrsh7th/cmp-nvim-lsp#setup
--
-- The nvim-cmp almost supports LSP's capabilities so You should advertise it to LSP servers.
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)

-- Use a loop to conveniently call 'setup' on multiple servers and
-- map buffer local keybindings when the language server attaches
--
-- bashls
--   $ npm install -g bash-language-server
-- tsserver
--   $ npm install -g typescript typescript-language-server
-- vimls
--   $ npm install -g vim-language-server
--
local servers = { "bashls", "gopls", "solargraph", "tsserver", "vimls" }
for _, lsp in ipairs(servers) do
  nvim_lsp[lsp].setup {
    on_attach = on_attach,
    capabilities = capabilities,
    flags = {
      debounce_text_changes = 150,
    }
  }
end

require('lspconfig').clangd.setup({
  cmd = { 'clangd', '--background-index', '-header-insertion=never' },
  handlers = lsp_status.extensions.clangd.setup(),
  init_options = {
    -- ref. https://clangd.llvm.org/extensions.html#file-status
    clangdFileStatus = true
  },
  on_attach = lsp_status.on_attach,
  capabilities = lsp_status.capabilities
})

-- Lua
require('lspconfig').sumneko_lua.setup({
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
        }
      }
    }
})

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

--
-- Print diagnostics to message area
-- ref. https://github.com/neovim/nvim-lspconfig/wiki/UI-customization#print-diagnostics-to-message-area
--
function PrintDiagnostics(opts, bufnr, line_nr, client_id)
  bufnr = bufnr or 0
  line_nr = line_nr or (vim.api.nvim_win_get_cursor(0)[1] - 1)
  opts = opts or {['lnum'] = line_nr}

  local line_diagnostics = vim.diagnostic.get(bufnr, opts)
  if vim.tbl_isempty(line_diagnostics) then return end

  local diagnostic_message = ""
  for i, diagnostic in ipairs(line_diagnostics) do
    diagnostic_message = diagnostic_message .. string.format("%d: %s", i, diagnostic.message or "")
    print(diagnostic_message)
    if i ~= #line_diagnostics then
      diagnostic_message = diagnostic_message .. "\n"
    end
  end
  vim.api.nvim_echo({{diagnostic_message, "Normal"}}, false, {})
end

vim.cmd [[ autocmd! CursorHold * lua PrintDiagnostics() ]]

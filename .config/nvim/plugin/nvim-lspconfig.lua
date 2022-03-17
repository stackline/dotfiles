if vim.api.nvim_get_var('plugs')["nvim-lspconfig"] == nil then
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
end


-- -------------------------------------
-- nvim-cmp autocompletion
-- ref. https://github.com/neovim/nvim-lspconfig/wiki/Autocompletion#nvim-cmp
-- -------------------------------------
-- Add additional capabilities supported by nvim-cmp
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)

local lspconfig = require('lspconfig')

-- Use a loop to conveniently call 'setup' on multiple servers and
-- map buffer local keybindings when the language server attaches
local servers = { 'bashls', 'gopls', 'solargraph', 'tsserver', 'vimls' }
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
require('lspconfig').clangd.setup({
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
      }
    }
  }
}


-- -------------------------------------
-- Custom settings
-- -------------------------------------
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

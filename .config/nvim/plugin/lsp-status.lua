if vim.api.nvim_get_var('plugs')["lsp-status.nvim"] == nil then
  return
end

local lsp_status = require('lsp-status')

lsp_status.register_progress()

-- Do not use iconic fonts as diagnostics symbols.
-- ref. h: lsp-status.config
lsp_status.config({
  current_function = false,
  indicator_errors = 'E',
  indicator_warnings = 'W',
  indicator_info = 'i',
  indicator_hint = '?',
  indicator_ok = 'Ok',
  status_symbol = 'LSP:',
})

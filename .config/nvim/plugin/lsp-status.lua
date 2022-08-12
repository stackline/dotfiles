local ok, lsp_status = pcall(require, 'lsp-status')
if not ok then
  print('lsp-status.nvim is not loaded.')
  return
end

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

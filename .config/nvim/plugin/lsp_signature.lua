local ok, lsp_signature = pcall(require, 'lsp_signature')
if not ok then
  print('lsp_signature.nvim is not loaded.')
  return
end

lsp_signature.setup({
  hint_prefix = "",
})

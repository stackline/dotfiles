local ok, module = pcall(require, 'trouble')
if not ok then
  print('trouble.nvim is not loaded.')
  return
end

module.setup {
  icons = false,
}

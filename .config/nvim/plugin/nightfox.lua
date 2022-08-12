local ok, _ = pcall(require, 'nightfox')
if not ok then
  print('nightfox.nvim is not loaded.')
  return
end

vim.cmd("colorscheme nightfox")

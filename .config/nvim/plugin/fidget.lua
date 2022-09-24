local ok, fidget = pcall(require, 'fidget')
if not ok then
  print('fidget.nvim is not loaded.')
  return
end

fidget.setup {}

if vim.fn['PlugIsNotInstalled']('nightfox.nvim') then
  return
end

vim.cmd("colorscheme nightfox")
-- vim.cmd("colorscheme nordfox")

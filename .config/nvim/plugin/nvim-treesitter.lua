local ok, configs = pcall(require, 'nvim-treesitter.configs')
if not ok then
  print('nvim-treesitter is not loaded.')
  return
end

configs.setup {
  highlight = {
    enable = true, -- false will disable the whole extension
    disable = {},  -- list of language that will be disabled
    additional_vim_regex_highlighting = true, -- make vim-endwise work fine
  },
}

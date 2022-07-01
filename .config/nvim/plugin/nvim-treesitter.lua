if vim.fn['PlugIsNotInstalled']('nvim-treesitter') then
  return
end

-- ref. https://github.com/nvim-treesitter/nvim-treesitter#setup
require'nvim-treesitter.configs'.setup {
  highlight = {
    enable = true, -- false will disable the whole extension
    disable = {},  -- list of language that will be disabled
    additional_vim_regex_highlighting = true, -- make vim-endwise work fine
  },
}

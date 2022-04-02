if vim.fn['PlugIsNotRegistered']('nvim-treesitter') then
  return
end

-- ref. https://github.com/nvim-treesitter/nvim-treesitter#setup
require'nvim-treesitter.configs'.setup {
  highlight = {
    enable = true, -- false will disable the whole extension
    disable = {},  -- list of language that will be disabled
    -- If you do not set true to "additional_vim_regex_highlighting" option,
    -- vim-endwise plugin does not insert "end" keyword.
    --
    -- NOTE:
    -- > Using this option may slow down your editor, and you may see some duplicate highlights.
    --
    -- ref. https://github.com/nvim-treesitter/nvim-treesitter/issues/1019#issuecomment-811658387
    additional_vim_regex_highlighting = true,
  },
}

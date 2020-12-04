" ref. https://github.com/nvim-treesitter/nvim-treesitter#setup
if has_key(g:plugs, 'nvim-treesitter')
  lua <<EOF
  require'nvim-treesitter.configs'.setup {
    highlight = {
      enable = true, -- false will disable the whole extension
      disable = {},  -- list of language that will be disabled
    },
  }
EOF
endif

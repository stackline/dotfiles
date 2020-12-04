" ref. https://github.com/nvim-treesitter/nvim-treesitter#setup
if has_key(g:plugs, 'nvim-treesitter')
  lua <<EOF
  require'nvim-treesitter.configs'.setup {
    -- NOTE: When starting Vim, it takes 3 msec to process
    -- the "ensure_installed" option. Therefore, instead of specifying
    -- the option, run ":TSInstall maintained" as needed.
    --
    -- ensure_installed = "maintained",
    highlight = {
      enable = true,              -- false will disable the whole extension
      disable = { "c", "rust" },  -- list of language that will be disabled
    },
  }
EOF
endif

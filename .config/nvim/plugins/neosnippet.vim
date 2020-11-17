if has_key(g:plugs, 'neosnippet.vim')
  " Disable all runtime snippets
  let g:neosnippet#disable_runtime_snippets = { '_' : 1, }

  " Use custom snippets
  let g:neosnippet#snippets_directory='~/.local/share/nvim/plugged/vim-snippets/snippets'
endif

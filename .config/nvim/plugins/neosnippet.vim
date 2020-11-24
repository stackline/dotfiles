if has_key(g:plugs, 'neosnippet.vim')
  " Disable all runtime snippets
  let g:neosnippet#disable_runtime_snippets = { '_' : 1, }

  " Use custom snippets
  let g:neosnippet#snippets_directory='~/.config/nvim/snippets'
endif

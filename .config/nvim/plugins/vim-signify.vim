if has_key(g:plugs, 'vim-signify')
  " default updatetime 4000ms is not good for async update
  set updatetime=100

  " Give priority to display LSP diagnostic signs.
  "
  " > The default priority for a sign is 10.
  " ref. :h sigh-priority
  "
  let g:signify_priority = 9
endif

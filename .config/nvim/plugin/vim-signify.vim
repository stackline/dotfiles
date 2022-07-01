if PlugIsNotInstalled('vim-signify')
  finish
endif

" default updatetime 4000ms is not good for async update
set updatetime=100

" Give priority to display LSP diagnostic signs.
"
" > The default priority for a sign is 10.
" ref. :h sigh-priority
"
let g:signify_priority = 9

" The following error occurs on the 3rd line of sy#highlight#line_disable,
" so change the setting temporarily.
"
"   E239: Invalid sign text
"
let g:signify_sign_change_delete = '!'

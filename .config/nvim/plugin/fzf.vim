if PlugIsNotInstalled('fzf.vim')
  finish
endif

nnoremap <C-p> :GFiles<cr>
nnoremap <expr> <C-j> ':Rg ' . expand('<cword>') . '<cr>'

" Incremental search by the word at cursor position.
"
" fzf options:
"   +i = search mode: case-sensitive match
"
nnoremap <silent> <C-\> :call fzf#vim#tags('^' . expand('<cword>'), { 'options': '+i' })<CR>

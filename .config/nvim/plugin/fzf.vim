if PlugIsNotInstalled('fzf.vim')
  finish
endif

" --cached
"   Show cached files in the output (default)
"
" --others
"   Show other files (i.e. untracked files) in the output
"
" --exclude-standard
"   Exclude files according to the settings in the gitignore file
nnoremap <C-p> :GFiles --cached --others --exclude-standard<cr>
nnoremap <expr> <C-j> ':Rg ' . expand('<cword>') . '<cr>'

" Incremental search by the word at cursor position.
"
" fzf options:
"   +i = search mode: case-sensitive match
"
nnoremap <silent> <C-\> :call fzf#vim#tags('^' . expand('<cword>'), { 'options': '+i' })<CR>

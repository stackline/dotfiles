if PlugIsNotInstalled('fzf.vim')
  finish
endif

" Don't show line number in the preview window.
" Change bat style option from '--style=numbers' to '--style=plain'.
"
" ref. https://github.com/junegunn/fzf.vim/blob/0452b71830b1a219b8cdc68141ee58ec288ea711/bin/preview.sh#L63
let $BAT_STYLE = 'plain'

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

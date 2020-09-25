" --------------------------------------
" fzf.vim
" https://github.com/junegunn/fzf.vim
" --------------------------------------

" Display fzf window at the bottom of window instead of the floating window.
" ref. https://github.com/junegunn/fzf/blob/master/README-VIM.md#configuration
let g:fzf_layout = { 'down': '40%' }

nnoremap <C-p> :GFiles<cr>
nnoremap <expr> <C-j> ':Rg ' . expand('<cword>') . '<cr>'

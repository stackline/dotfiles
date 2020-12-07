" --------------------------------------
" fzf.vim
" https://github.com/junegunn/fzf.vim
" --------------------------------------

nnoremap <C-p> :GFiles<cr>
nnoremap <expr> <C-j> ':Rg ' . expand('<cword>') . '<cr>'

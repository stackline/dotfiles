" --------------------------------------
" Terminal
" --------------------------------------

" NOTE: When executing Vim in the terminal emulator,
" <C-[> command make original Vim normal-mode.
"
" tnoremap <C-[> <C-\><C-n>

" Enable to move of a cursor to another window on terminal-mode
" ref. help CTRL-W_w
tnoremap <C-w>w <C-\><C-n><C-w>w
tnoremap <C-w><C-w> <C-\><C-n><C-w>w

command! Term split | terminal
command! Termv vsplit | terminal

augroup initialize_terminal_event
  autocmd!

  " Start terminal in insert mode instead of normal mode
  "
  " New terminal
  autocmd TermOpen term://* startinsert
  " Existing terminal
  autocmd WinEnter * if &buftype ==# 'terminal' | startinsert | endif

  " TODO: Consider the way to not quitting when returning non zero exit status.
  autocmd TermClose term://* :q
augroup END

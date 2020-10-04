" --------------------------------------
" vim-asynctags
" https://github.com/stackline/vim-asynctags
" --------------------------------------

" nnoremap <C-]> :RCTagsJump<cr>
" augroup rctags_set_tags
"   autocmd BufNewFile,BufRead *.ruby set tags+=system('git rev-parse --show-toplevel | tr -d "\n"') . '/tags'
" augroup END
"
" let g:asynctags_ctags_options = []
" let g:asynctags_ctags_options = add(g:asynctags_ctags_options, '-R')
" let g:asynctags_ctags_options = add(g:asynctags_ctags_options, '--languages=ruby')
" let g:asynctags_ctags_options = g:asynctags_ctags_options

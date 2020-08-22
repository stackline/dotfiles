" --------------------------------------
" ale
" --------------------------------------

" Do not use LSP because other plugin use LSP
let g:ale_disable_lsp = 1
" Change rubocop execution command from 'rubocop' to 'bundle exec rubocop'
" ref. help ale-ruby-rubocop
let g:ale_ruby_rubocop_executable = 'bundle'

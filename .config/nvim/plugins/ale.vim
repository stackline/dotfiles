" --------------------------------------
" ale
" --------------------------------------

" Do not use LSP because other plugin use LSP
let g:ale_disable_lsp = 1

" --------------------
" C++
" --------------------
let g:ale_cpp_cc_executable = 'g++-9'
let g:ale_cpp_cc_options    = '-std=gnu++17 -Wall -Wextra'

" --------------------
" Ruby
" --------------------
" Change rubocop execution command from 'rubocop' to 'bundle exec rubocop'
" ref. help ale-ruby-rubocop
let g:ale_ruby_rubocop_executable = 'bundle'

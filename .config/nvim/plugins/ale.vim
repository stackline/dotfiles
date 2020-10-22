" --------------------------------------
" ale
" --------------------------------------

" Do not use LSP because other plugin use LSP
let g:ale_disable_lsp = 1

" Fix code when they are saved
let g:ale_fix_on_save = 1
let g:ale_fixers = {
  \ 'cpp': ['clang-format'],
  \ 'go': ['gofmt']
  \ }

" --------------------
" C++
" --------------------
let g:ale_cpp_cc_executable = 'g++-9'
let g:ale_cpp_cc_options    = '-std=gnu++17 -Wall -Wextra'
" --
"   Since being able to pass options to clang with --extra-arg option, use --.
" -x c++
"   clang-check treats input file as c language.
"   When including iostream header, iostream file not found error occurs.
"   Therefore, specify c++ as an option.
" -I/usr/local/include
"   Include /usr/local/include/bits/stdc++.h
"   NOTE: IF passing options to clang with '--', it may not refer to options in the compile_flags.txt.
" -std=c++17
" -stdlib=libc++
" -Wall
"   AtCoder clang++ compile option
"   ref. https://atcoder.jp/contests/language-test-202001
let g:ale_cpp_clangcheck_options = '-- -x c++ -I/usr/local/include -std=c++17 -stdlib=libc++ -Wall'

" --------------------
" Ruby
" --------------------
" Change rubocop execution command from 'rubocop' to 'bundle exec rubocop'
" ref. help ale-ruby-rubocop
let g:ale_ruby_rubocop_executable = 'bundle'

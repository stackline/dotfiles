if PlugIsNotInstalled('ale')
  finish
endif

" Do not use LSP because other plugin use LSP
let g:ale_disable_lsp = 1

" Fix code when they are saved
let g:ale_fix_on_save = 1

" Mapping of filetype and formatters
let g:ale_fixers = {
\  'cpp': ['clang-format'],
\  'go': ['goimports'],
\  'ruby': ['rubocop'],
\  'sh': ['shfmt'],
\}

" Mapping of filetype and linters
"
" cpp: Check with clangd (LSP) using the compile options of compile_flags.txt.
" go: nvim-lint
" ruby: nvim-lint
let g:ale_linters = {
\  'cpp': [],
\  'dockerfile': [],
\  'go': [],
\  'ruby': [],
\  'sh': [],
\  'vim': ['vint'],
\}

" A style similar to Google's shell style
"
" -i 2 : indent two spaces.
" -ci  : indent the next line of the case statement.
let g:ale_sh_shfmt_options = '-i 2 -ci'

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

" NOTE: Set goimports as a fixer for the go file with ALE.
" Then, when I exit the go file with :wq, an error occurs.
"
" Related issue: https://github.com/dense-analysis/ale/issues/1960
function! ALEQuitToDiscardError()
  try
    quit
  endtry
endfunction

augroup ale_quit_to_discard_error
  autocmd!
  " autocmd QuitPre *.go quit
  autocmd QuitPre *.go call ALEQuitToDiscardError()
augroup END

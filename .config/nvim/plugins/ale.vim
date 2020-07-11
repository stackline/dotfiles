" --------------------------------------
" ale
" --------------------------------------
" Do not use LSP because other plugin use LSP
let g:ale_disable_lsp = 1
let g:ale_php_phpcs_standard = 'PSR1,PSR2'
let g:ale_php_phpcs_executable = '/usr/bin/phpcs'
" Change rubocop executable from 'rubocop' to 'bundle exec rubocop'
" ref. help ale-ruby-rubocop
let g:ale_ruby_rubocop_executable = 'bundle'

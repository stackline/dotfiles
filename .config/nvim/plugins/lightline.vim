" --------------------------------------
" lightline
" --------------------------------------
" Return current repository name
function! MyRepository()
  let s:absolute_git_root_dir = system('git rev-parse --show-toplevel')
  if v:shell_error == 0
    let s:repository_name = fnamemodify(s:absolute_git_root_dir, ':t')
    return substitute(s:repository_name, "\n", '', '')
  endif
  return ''
endfunction

" show relative path
" ref. https://github.com/itchyny/lightline.vim/issues/87#issuecomment-189616314
let g:lightline = {
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ], [  'cocstatus', 'readonly', 'repository', 'gitbranch', 'relativepath', 'modified' ] ]
      \ },
      \ 'component_function': {
      \   'gitbranch': 'gitbranch#name',
      \   'repository': 'MyRepository',
      \   'cocstatus': 'coc#status'
      \ }
      \ }

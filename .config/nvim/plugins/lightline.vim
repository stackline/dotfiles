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

" NOTE: require vim-gitbranch plugin
" https://github.com/itchyny/lightline.vim/issues/293#issuecomment-373710096
function! LightlineFilename()
  let root = fnamemodify(get(b:, 'gitbranch_path'), ':h:h')
  let path = expand('%:p')
  if path[:len(root)-1] ==# root
    return path[len(root)+1:]
  endif
  return expand('%')
endfunction

let g:lightline = {
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ], [  'cocstatus', 'readonly', 'repository', 'gitbranch', 'filename', 'modified' ] ]
      \ },
      \ 'component_function': {
      \   'cocstatus': 'coc#status',
      \   'repository': 'MyRepository',
      \   'gitbranch': 'gitbranch#name',
      \   'filename': 'LightlineFilename'
      \ }
      \ }

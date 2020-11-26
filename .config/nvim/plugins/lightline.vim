" ----------------------------------------------------------
" lightline.vim
" ----------------------------------------------------------

if !has_key(g:plugs, 'lightline.vim')
  finish
endif

" NOTE: Display LSP status and the file name as much as possible
" with the "%<" symbol.
" ref. https://github.com/itchyny/lightline.vim#how-can-i-truncate-the-components-from-the-right-in-narrow-windows
let g:lightline = {
    \ 'active': {
    \   'left': [ [ 'mode', 'paste' ],
    \             [ 'lspstatus', 'readonly', 'file', 'modified' ] ]
    \ },
    \ 'tabline': {
    \   'right': [ [ 'repository', 'branch' ] ]
    \ },
    \ 'component': {
    \   'repository': '%{b:statusline_repository_name}',
    \   'branch': '%{b:statusline_branch_name}',
    \   'file': '%{b:statusline_file_name}%<'
    \ },
    \ 'component_function': {
    \   'lspstatus': 'StatusLineLspStatus'
    \ },
    \ }

augroup statusline_cache_items
  autocmd!
  " NOTE: vim-fugitive sets `b:git_dir` variable at BufReadPost event.
  autocmd BufEnter * call StatusLineCacheItems()
augroup END

function! StatusLineCacheItems()
  let b:statusline_repository_name = StatusLineRepositoryName()
  let b:statusline_branch_name = StatusLineBranchName()
  let b:statusline_file_name = StatusLineFileName()
endfunction

" require: vim-fugitive plugin
function! StatusLineRepositoryName()
  if expand('%') == ''
    return ''
  endif

  let root = fnamemodify(get(b:, 'git_dir'), ':h')
  if root != ''
    return fnamemodify(root, ':t')
  endif
  return ''
endfunction

" require: vim-fugitive plugin
function! StatusLineBranchName()
  if expand('%') == ''
    return ''
  endif

  return fugitive#head()
endfunction

" require: vim-fugitive plugin
function! StatusLineFileName()
  if expand('%') == ''
    return '[No Name]'
  endif

  let root = fnamemodify(get(b:, 'git_dir'), ':h')
  let path = expand('%:p')
  if path[:len(root)-1] ==# root
    return path[len(root)+1:]
  endif
  return expand('%')
endfunction

function! StatusLineLspStatus()
  if has_key(g:plugs, 'lsp-status.nvim')
    return LspStatus()
  elseif has_key(g:plugs, 'coc.nvim')
    return coc#status()
  endif
  return ''
endfunction

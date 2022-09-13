if PlugIsNotInstalled('lightline.vim')
  finish
endif

" NOTE: Display LSP status and the file name as much as possible
" with the "%<" symbol.
" ref. https://github.com/itchyny/lightline.vim#how-can-i-truncate-the-components-from-the-right-in-narrow-windows
"
" NOTE: BufEnter event does not occurs when opening the filer.
" Use 'get' function to avoid variable undeclared errors.
let g:lightline = {
    \ 'colorscheme': 'nightfox',
    \ 'active': {
    \   'left': [ [ 'mode', 'paste' ],
    \             [ 'lspstatus', 'readonly', 'file', 'modified' ] ],
    \   'right': [ [ 'lineinfo-with-virtual-column-number' ],
    \              [ 'percent' ],
    \              [ 'fileformat', 'fileencoding', 'filetype' ] ]
    \ },
    \ 'tabline': {
    \   'right': [ [ 'repository', 'branch' ] ]
    \ },
    \ 'component': {
    \   'lineinfo-with-virtual-column-number': '%3l:%-2v',
    \   'repository': '%{get(b:, "statusline_repository_name", "")}',
    \   'branch': '%{get(b:, "statusline_branch_name", "")}',
    \   'file': '%{get(b:, "statusline_file_name", "")}%<'
    \ },
    \ 'component_function': {
    \   'lspstatus': 'StatusLineLspStatus'
    \ },
    \ }

" NOTE: Prevent the display positon of tabs from shifting when moving to
" another tab.
"
" left:  Separator sign of selected tabs of left part
" right: Unknown
let lightline.tabline_separator = { 'left': ' ', 'right': ' ' }
" left:  Separator sign of unselected tabs of left part
" right: Separator sign of repository name and branch name of right part
let lightline.tabline_subseparator = { 'left': '|', 'right': '|' }

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

  return FugitiveHead()
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
    " The value that the status function return includes half-width space on
    " the right side. Trim the extra right space off.
    return trim(luaeval("require('lsp-status').status()"))
  else
    return ''
  endif
endfunction

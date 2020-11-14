" --------------------------------------
" vim-crystalline
" --------------------------------------

" Preparation
" * Define global counter variable.
" * Increment the counter in the StatusLine function.
" * The sample code is below.
"
" ```
" let g:cnt = 0
" function! StatusLine(...)
"   let g:cnt = g:cnt + 1
" ```
"
function! MeasureTime()
  vsplit
  let start_cnt = g:cnt
  let start_time = reltime()
  for i in range(500)
    redrawstatus
  endfor
  let stop_time = reltime()
  let stop_cnt = g:cnt
  quit

  let elapsed_time = str2float(reltimestr(stop_time)) - str2float(reltimestr(start_time))
  let cnt_diff = stop_cnt - start_cnt

  echom string(elapsed_time) . ' sec / ' . cnt_diff . ' times'
  echom string(elapsed_time * 1000) . ' msec / ' . cnt_diff . ' times'
  echom string(elapsed_time * 1000 / cnt_diff) . ' msec by time'
endfunction

function! CrystallineRepositoryName()
  let s:absolute_git_root_dir = system('git rev-parse --show-toplevel')
  if v:shell_error == 0
    let s:repository_name = fnamemodify(s:absolute_git_root_dir, ':t')
    return substitute(s:repository_name, "\n", '', '')
  endif
  return ''
endfunction

" require: vim-fugitive plugin
" ref. https://github.com/itchyny/lightline.vim/issues/293#issuecomment-373710096
function! CrystallineFilename()
  let root = fnamemodify(get(b:, 'git_dir'), ':h')
  let path = expand('%:p')
  if path[:len(root)-1] ==# root
    return path[len(root)+1:]
  endif
  return expand('%')
endfunction

" TODO: Hide unnecessary separators.
" ref. https://github.com/rbong/vim-crystalline#adding-powerline-style-separators-between-sections
function! StatusLine(...)
  return crystalline#mode() . crystalline#right_mode_sep('')
        \ . ' %{coc#status()} | %{CrystallineRepositoryName()} | %{fugitive#head()} | %{CrystallineFilename()} %h%w%m%r ' . crystalline#right_sep('', 'Fill') . '%='
        \ . crystalline#left_sep('', 'Fill') . ' %{&ft}[%{&fenc!=#""?&fenc:&enc}][%{&ff}] %l/%L %c%V %P '
endfunction

let g:crystalline_enable_sep = 0
let g:crystalline_statusline_fn = 'StatusLine'
let g:crystalline_theme = 'default'
set laststatus=2

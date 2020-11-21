" --------------------------------------
" vim-crystalline
" --------------------------------------

function! MeasureTime()
  const TRIALS = 1000

  vsplit
  let start_time = reltime()
  for i in range(TRIALS)
    call CrystallineLeftContents()
  endfor
  let stop_time = reltime()
  quit

  let elapsed_time = str2float(reltimestr(stop_time)) - str2float(reltimestr(start_time))
  echom string(elapsed_time) . ' sec / ' . TRIALS . ' times'
  echom string(elapsed_time * 1000) . ' msec / ' . TRIALS . ' times'
  echom string(trunc(elapsed_time * 1000) / TRIALS) . ' msec by time'
endfunction

" NOTE: Considering when to destroy the cache
"
"   * Cache the current file name.
"   * If the current file name and the cached file name are different, retrieve
"     the repository name again.
"   * ref. https://vim.fandom.com/wiki/Get_the_name_of_the_current_file
"
function! CrystallineCachedRepositoryName()
  if !exists("w:crystalline_repository_name")
    let root = fnamemodify(FugitiveGitDir(), ':h')
    if root != ''
      let w:crystalline_repository_name = fnamemodify(root, ':t')
    endif
  endif
  return w:crystalline_repository_name
endfunction

function! CrystallineCachedBranchName()
  if !exists('w:crystalline_branch_name')
    let w:crystalline_branch_name = fugitive#head()
  endif
  return w:crystalline_branch_name
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

" NOTE: Consider whether the branch name should not be cached or updated asynchronously.
function! CrystallineLeftContents()
  if has_key(g:plugs, 'coc.nvim')
    let items = [coc#status(), CrystallineCachedRepositoryName(), CrystallineCachedBranchName(), CrystallineFilename()]
  else
    let items = [CrystallineCachedRepositoryName(), CrystallineCachedBranchName(), CrystallineFilename()]
  endif
  let filtered_items = filter(items, 'v:val != ""')
  let left_contents = join(filtered_items, ' | ')
  return left_contents
endfunction

" ref. https://github.com/rbong/vim-crystalline#adding-powerline-style-separators-between-sections
function! StatusLine(...)
  if !exists('s:crystalline_cached_sep')
    let s:crystalline_right_mode_sep = crystalline#right_mode_sep('')
    let s:crystalline_right_sep = crystalline#right_sep('', 'Fill')
    let s:crystalline_left_sep = crystalline#left_sep('', 'Fill')
    let s:crystalline_cached_sep = 1
  endif

  return crystalline#mode() . s:crystalline_right_mode_sep
        \ . ' %{CrystallineLeftContents()} %h%w%m%r ' . s:crystalline_right_sep . '%='
        \ . s:crystalline_left_sep . ' %{&ft}[%{&fenc!=#""?&fenc:&enc}][%{&ff}] %l/%L %c%V %P '
endfunction

let g:crystalline_enable_sep = 0
let g:crystalline_statusline_fn = 'StatusLine'
let g:crystalline_theme = 'default'
set laststatus=2

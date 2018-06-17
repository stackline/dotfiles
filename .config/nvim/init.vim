" --------------------------------------
" dein.vim
" MEMO: remove plugin
" ref. https://github.com/Shougo/dein.vim/issues/71#issuecomment-208601678
" --------------------------------------
if &compatible
  set nocompatible " Be iMproved
endif

let s:path = expand('~/.cache/dein')
let s:runtimepath = expand(s:path . '/repos/github.com/Shougo/dein.vim')

execute 'set runtimepath+=' . s:runtimepath

if dein#load_state(s:path)
  call dein#begin(s:path)

  " Let dein manage dein
  call dein#add(s:runtimepath)

  " Add or remove your plugins here:
  call dein#add('w0rp/ale') " linter
  call dein#add('ludovicchabant/vim-gutentags') " ctags generator
  call dein#add('tpope/vim-fugitive') " git wrapper
  " call dein#add('tpope/vim-rails')
  " call dein#add('joonty/vdebug', { 'rev': 'v1.5.2' })
  " call dein#add('Shougo/neosnippet.vim')
  " call dein#add('Shougo/neosnippet-snippets')

  " ----------------------------------------
  " additional information
  " ----------------------------------------
  call dein#add('airblade/vim-gitgutter') " git diff
  call dein#add('itchyny/lightline.vim')  " statusline
  call dein#add('nathanaelkane/vim-indent-guides')
  call dein#add('ntpeters/vim-better-whitespace')

  " ----------------------------------------
  " incremental search
  " ----------------------------------------
  call dein#add('ctrlpvim/ctrlp.vim') " file search
  call dein#add('mileszs/ack.vim')    " code search

  " ----------------------------------------
  " auto complete
  " ----------------------------------------
  call dein#add('Shougo/deoplete.nvim')
  call dein#add('jiangmiao/auto-pairs')
  call dein#add('tpope/vim-endwise')

  " ----------------------------------------
  " syntax highlight
  " ----------------------------------------
  call dein#add('cocopon/iceberg.vim') " color scheme
  call dein#add('slim-template/vim-slim') " slim

  call dein#end()
  call dein#save_state()
endif


" --------------------------------------
" vim-better-whitespace
" --------------------------------------
highlight ExtraWhitespace ctermbg=red
let g:better_whitespace_enabled=1
let g:strip_whitespace_on_save=1


" --------------------------------------
" ctags
" --------------------------------------
" Show the list when it has many candidates
nnoremap <C-]> g<C-]>


" --------------------------------------
" ctrlp
" --------------------------------------
" ref. https://elliotekj.com/2016/11/22/setup-ctrlp-to-use-ripgrep-in-vim/
if executable('rg')
  set wildignore+=*/.git/*,*/tmp/*,*.swp
  set grepprg=rg\ --color=never

  " Open a quickfix-window to "grep" and "Ggrep" command
  autocmd QuickFixCmdPost vimgrep cwindow
  autocmd QuickFixCmdPost *grep* cwindow

  let g:ctrlp_user_command = 'rg %s --files --color=never --glob ""'
  let g:ctrlp_use_caching = 0
endif


" --------------------------------------
" ack.vim
" --------------------------------------
if executable('rg')
  let g:ackprg = 'rg --vimgrep --no-heading'
endif


" --------------------------------------
" lightline
" --------------------------------------
" Return current repository name
function! MyRepository()
  let s:absolute_git_root_dir = system('git rev-parse --show-toplevel')
  if v:shell_error == 0
    let s:repository_name = fnamemodify(s:absolute_git_root_dir, ":t")
    return substitute(s:repository_name, "\n", '', '')
  endif
  return ''
endfunction

" show relative path
" ref. https://github.com/itchyny/lightline.vim/issues/87#issuecomment-189616314
let g:lightline = {
      \ 'colorscheme': 'iceberg',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ], [ 'readonly', 'repository', 'relativepath', 'modified' ] ]
      \ },
      \ 'component_function': {
      \   'repository': 'MyRepository'
      \ }
      \ }


" --------------------------------------
" deoplete
" --------------------------------------
let g:deoplete#enable_at_startup = 1
" focus first word by default
set completeopt+=noinsert
" complement with the tab key
inoremap <expr> <Tab> pumvisible() ? "\<Enter>" : "\<Tab>"


" --------------------------------------
" vim-gitgutter
" --------------------------------------
set updatetime=250


" --------------------------------------
" ale
" --------------------------------------
let g:ale_linters = {
      \ 'php': ['phpcs', 'php']
      \}
let g:ale_php_phpcs_standard = 'PSR1,PSR2'
let g:ale_php_phpcs_executable = '/usr/bin/phpcs'


" --------------------------------------
" tab jump
" ref. https://qiita.com/wadako111/items/755e753677dd72d8036d
" --------------------------------------
" jump to the target tab by specify the number (t1, t2, t3...)
for n in range(1, 9)
  execute 'nnoremap <silent> t'.n  ':<C-u>tabnext'.n.'<CR>'
endfor

nnoremap <silent> tc :tablast <bar> tabnew<CR>
nnoremap <silent> tx :tabclose<CR>
nnoremap <silent> tn :tabnext<CR>
nnoremap <silent> tp :tabprevious<CR>


" --------------------------------------
" common
" --------------------------------------
colorscheme iceberg
set number
set list
set nowrap
set nofixeol
set incsearch  " incremental search
set ignorecase " ignore upper case and lower case
set splitbelow " open splited window to below
set splitright " open splited window to right
set noswapfile " do not make .swp swap file
set nobackup   " do not make tilda "~" backup file
set ambiwidth=double " Show two byte character collectory on Mac Termianl"
set formatoptions=tcrqj " Default `tcqj`. Add `r` option (complete comment sign automatically when breaking line)


" --------------------------------------
" filetype indent
" --------------------------------------
set expandtab
set shiftwidth=2
set tabstop=2

filetype plugin on
filetype indent on
autocmd FileType javascript setlocal expandtab shiftwidth=2 tabstop=2 softtabstop=2
autocmd FileType php        setlocal expandtab shiftwidth=4 tabstop=4 softtabstop=4
autocmd FileType ruby       setlocal expandtab shiftwidth=2 tabstop=2 softtabstop=2
autocmd FileType sh         setlocal expandtab shiftwidth=2 tabstop=2 softtabstop=2

" Use Ruby syntax highlight on Brewfile
" ref. http://vim-jp.org/vimdoc-ja/filetype.html#ftdetect
autocmd BufRead,BufNewFile Brewfile,.Brewfile setfiletype ruby

" When editing a file, always jump to the last cursor position
" ref. /etc/vimrc
if has("autocmd")
  augroup redhat
    autocmd!
    autocmd BufReadPost *
            \ if line("'\"") > 0 && line ("'\"") <= line("$") |
            \   exe "normal! g'\"" |
            \ endif
  augroup END
endif


" Utility
function! GitUrl()
  let l:TEMPLATE = $GIT_CODE_URL
  if l:TEMPLATE == ""
    echo 'Please define `GIT_CODE_URL` environment variable'
    return
  endif

  let l:project    = system('git remote get-url origin | sed "s/\// /g" | awk ''{print $(NF-1)}'' | tr ''[:lower:]'' ''[:upper:]'' | tr -d "\n"')
  let l:repository = system('git remote get-url origin | sed "s/\// /g" | awk ''{print $(NF)}'' | sed "s/.git$//" | tr -d "\n"')
  let l:path       = system('git rev-parse --show-prefix | tr -d "\n"') . expand('%')
  let l:remote_url = substitute(substitute(substitute(l:TEMPLATE, '__PROJECT__', l:project, ''), '__REPOSITORY__', l:repository, ''), '__PATH__', l:path, '')

  echo l:remote_url
endfunction
command! GitUrl call GitUrl()


" --------------------------------------
" vim-indent-guides
" --------------------------------------
let g:indent_guides_enable_on_vim_startup = 1
let g:indent_guides_start_level = 2
let g:indent_guides_guide_size = 1
autocmd VimEnter,Colorscheme * hi IndentGuidesEven ctermbg=235
autocmd VimEnter,Colorscheme * hi IndentGuidesOdd  ctermbg=236


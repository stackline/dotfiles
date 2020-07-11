" --------------------------------------
" vim-plug
" --------------------------------------
call plug#begin('~/.local/share/nvim/plugged')

Plug 'w0rp/ale' " linter
Plug 'prabirshrestha/async.vim'
Plug 'stackline/vim-asynctags', { 'for': 'ruby' } " Async ctag generator
Plug 'tpope/vim-fugitive' " git wrapper
" Plug 'tpope/vim-rails'
" Plug 'joonty/vdebug', { 'rev': 'v1.5.2' }

" Testing framework for Vim script
Plug 'thinca/vim-themis', { 'do': 'ln -fsv `pwd`/bin/themis /usr/local/bin/themis' }

" ----------------------------------------
" additional information
" ----------------------------------------
Plug 'airblade/vim-gitgutter' " git diff
Plug 'itchyny/lightline.vim'  " statusline
Plug 'itchyny/vim-gitbranch'  " git branch name

" ----------------------------------------
" incremental search
" ----------------------------------------
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim' " Incremental file and code search

" ----------------------------------------
" LSP client
" ----------------------------------------
Plug 'neoclide/coc.nvim', {'branch': 'release'}
" coc extensions
" ref. https://github.com/neoclide/coc.nvim/wiki/Using-coc-extensions#install-extensions
"
"   :CocInstall coc-solargraph
"

" ----------------------------------------
" auto complete
" ----------------------------------------
Plug 'jiangmiao/auto-pairs'
Plug 'tpope/vim-endwise'

" ----------------------------------------
" syntax highlight
" ----------------------------------------
Plug 'crusoexia/vim-monokai'
Plug 'slim-template/vim-slim' " slim

call plug#end()

" When [!] is included, all found files are sourced.
runtime! plugins/*.vim

" --------------------------------------
" rctags.vim
" https://github.com/stackline/rctags.vim
" --------------------------------------
let g:asynctags_ctags_options = []
let g:asynctags_ctags_options = add(g:asynctags_ctags_options, '-R')
let g:asynctags_ctags_options = add(g:asynctags_ctags_options, '--languages=ruby')
let g:asynctags_ctags_options = g:asynctags_ctags_options

" --------------------------------------
" ctags
" --------------------------------------
" " Show the list when it has many candidates
" " Use :tjump instead of :tag
" nnoremap <C-]> g<C-]>
nnoremap <C-]> :RCTagsJump<cr>
augroup rctags_set_tags
  autocmd BufNewFile,BufRead *.ruby set tags+=system('git rev-parse --show-toplevel | tr -d "\n"') . '/tags'
augroup END

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
colorscheme monokai

" Enable true color (24-bit color) in the TUI.
"
" MEMO:
" Hyper v3.0.2 does not support true color. (Specifically, xterm.js)
" Therefore, the color scheme is represented by 8-bit color (256 colors).
"
" To use true color in Hyper, we need to build canary or wait for v4.
" ref. True colors support / https://github.com/zeit/hyper/issues/3695
"
set termguicolors
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
set tagcase=match " Search a tag file by case match


" --------------------------------------
" filetype indent
" --------------------------------------
set expandtab
set shiftwidth=2
set tabstop=2

filetype plugin on
filetype indent on


" --------------------------------------
" Autocommands
" --------------------------------------
augroup init_filetype_event
  autocmd!

  autocmd FileType javascript setlocal expandtab shiftwidth=2 tabstop=2 softtabstop=2
  autocmd FileType php        setlocal expandtab shiftwidth=4 tabstop=4 softtabstop=4
  autocmd FileType ruby       setlocal expandtab shiftwidth=2 tabstop=2 softtabstop=2
  autocmd FileType sh         setlocal expandtab shiftwidth=2 tabstop=2 softtabstop=2

  " Enable tag jump to methods with ! or ?
  " ref. https://www.reddit.com/r/vim/comments/60el1r/question_jumping_to_tags/
  autocmd FileType ruby setlocal iskeyword+=!,?
augroup END

augroup init_bufwritepre_event
  autocmd!

  " Delete unnecessary trailing spaces
  autocmd BufWritePre * :%s/\s\+$//ge
augroup END

augroup init_bufnewfile_bufreadpost_event
  autocmd!

  " Use Ruby syntax highlight on Brewfile
  " ref. http://vim-jp.org/vimdoc-ja/filetype.html#ftdetect
  autocmd BufNewFile,BufReadPost Brewfile,.Brewfile setfiletype ruby
  autocmd BufNewFile,BufReadPost *.php set tags+=~/.cache/ctags/php.tags
augroup END

augroup init_bufreadpost_event
  autocmd!

  " When editing a file, always jump to the last cursor position
  autocmd BufReadPost *
        \ if line("'\"") > 0 && line ("'\"") <= line("$") |
        \   exe "normal! g'\"" |
        \ endif
augroup END


" Utility
function! GetURLComponents()
  let l:remote_url = system('git remote get-url origin | tr -d "\n"')
  let l:components = split(l:remote_url, '/')

  " scheme
  let l:scheme = 'https'

  " authority
  let l:authority = l:components[2]

  if match(l:authority, '@') >= 1
    let l:sub_components = split(l:authority, '@')
    let l:userinfo = l:sub_components[0]
    let l:remaining_authority = l:sub_components[1]
  else
    let l:userinfo = ''
    let l:remaining_authority = l:authority
  endif

  if match(l:remaining_authority, ':') >= 1
    let l:sub_components = split(l:remaining_authority, ':')
    let l:host = l:sub_components[0]
    let l:port = l:sub_components[1]
  else
    let l:host = l:remaining_authority
    let l:port = ''
  endif

  " path
  let l:user_name = l:components[3]
  let l:repository_name = system('git rev-parse --show-toplevel | xargs basename | tr -d "\n"')
  let l:file_path  = system('git rev-parse --show-prefix | tr -d "\n"') . expand('%')

  return {'scheme': l:scheme,
        \ 'userinfo': l:userinfo,
        \ 'host': l:host,
        \ 'port': l:port,
        \ 'user_name': l:user_name,
        \ 'repository_name': l:repository_name,
        \ 'file_path': l:file_path
        \ }
endfunction

function! BitbucketUrl()
  let l:components = GetURLComponents()
  let l:path = '/' . 'projects'
           \ . '/' . toupper(l:components['user_name'])
           \ . '/' . 'repos'
           \ . '/' . l:components['repository_name']
           \ . '/' . 'browse'
           \ . '/' . l:components['file_path']

  echo l:components['scheme'] . '://' . l:components['host'] . l:path
endfunction
command! BitbucketUrl call BitbucketUrl()

function! GitHubUrl()
  let l:components = GetURLComponents()
  let l:path = '/' . l:components['user_name']
           \ . '/' . l:components['repository_name']
           \ . '/' . 'blob'
           \ . '/' . 'master'
           \ . '/' . l:components['file_path']

  echo l:components['scheme'] . '://' . l:components['host'] . l:path
endfunction
command! GitHubUrl call GitHubUrl()


" --------------------------------------
" coc.nvim
" ref. https://github.com/neoclide/coc.nvim#example-vim-configuration
" --------------------------------------
" if hidden is not set, TextEdit might fail.
set hidden

" Some servers have issues with backup files, see #649
set nobackup
set nowritebackup

" Smaller updatetime for CursorHold & CursorHoldI
set updatetime=300

" don't give |ins-completion-menu| messages.
set shortmess+=c

" always show signcolumns
set signcolumn=yes

" Use <c-space> to trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()

" Remap keys for gotos
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gr <Plug>(coc-references)

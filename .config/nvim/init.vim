" --------------------------------------
" vim-plug
" --------------------------------------
call plug#begin('~/.local/share/nvim/plugged')

" --------------------------------------
" Common settings
" --------------------------------------
Plug 'airblade/vim-gitgutter' " git diff
Plug 'crusoexia/vim-monokai'  " syntax highlight
Plug 'itchyny/lightline.vim'  " statusline
Plug 'itchyny/vim-gitbranch'  " git branch name
Plug 'jiangmiao/auto-pairs'
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'       " Incremental file and code search
Plug 'neoclide/coc.nvim', { 'branch': 'release' }
let s:exts = []
let s:exts = add(s:exts, 'coc-json')       " for json
let s:exts = add(s:exts, 'coc-clangd')     " for c/c++/objective-c, use clangd
let s:exts = add(s:exts, 'coc-snippets')   " snippets
let s:exts = add(s:exts, 'coc-solargraph') " for ruby, use solargraph
let s:exts = add(s:exts, 'coc-tsserver')   " for javascript and typescript
let g:coc_global_extensions = s:exts
Plug 'sheerun/vim-polyglot'
Plug 'tpope/vim-endwise'
Plug 'tpope/vim-fugitive'     " git wrapper (mainly use git blame only)
Plug 'dense-analysis/ale'     " linter

" --------------------------------------
" Language specific settings
" --------------------------------------
" c++
Plug 'bfrg/vim-cpp-modern', { 'for': 'cpp' } " preferred over vim-polyglot
Plug 'honza/vim-snippets', { 'for': 'cpp' }

" php
" Plug 'joonty/vdebug', {  'for': 'php', 'rev': 'v1.5.2' }

" ruby
" Plug 'prabirshrestha/async.vim', { 'for': 'ruby' }
" Plug 'stackline/vim-asynctags', { 'for': 'ruby' } " Async ctag generator

" vim
" NOTE: Do not load vim-themis plugin because it is a plugin used as a CUI
" command during test execution
Plug 'thinca/vim-themis', { 'for': 'none', 'do': 'ln -fsv `pwd`/bin/themis /usr/local/bin/themis' }

call plug#end()

" When [!] is included, all found files are sourced.
runtime! plugins/*.vim

" --------------------------------------
" ctags
" --------------------------------------
" " Show the list when it has many candidates
" " Use :tjump instead of :tag
" nnoremap <C-]> g<C-]>

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
" Unify to monokai line number font color
" https://github.com/crusoexia/vim-monokai/blob/master/colors/monokai.vim
highlight Comment ctermfg=243 guifg=#8F908A

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

  autocmd FileType go         setlocal noexpandtab shiftwidth=4 tabstop=4 softtabstop=4
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

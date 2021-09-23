" Disable unused default plugins
let g:loaded_gzip               = 1
let g:loaded_tar                = 1
let g:loaded_tarPlugin          = 1
let g:loaded_zip                = 1
let g:loaded_zipPlugin          = 1
let g:loaded_rrhelper           = 1
let g:loaded_vimball            = 1
let g:loaded_vimballPlugin      = 1
let g:loaded_getscript          = 1
let g:loaded_getscriptPlugin    = 1
let g:loaded_netrw              = 1
let g:loaded_netrwPlugin        = 1
let g:loaded_netrwSettings      = 1
let g:loaded_netrwFileHandlers  = 1
let g:did_install_default_menus = 1
let g:skip_loading_mswin        = 1
let g:did_install_syntax_menu   = 1
let g:loaded_2html_plugin       = 1
" let loaded_matchparen           = 1

" --------------------------------------
" vim-plug
" --------------------------------------
call plug#begin('~/.local/share/nvim/plugged')

Plug 'dense-analysis/ale'              " linter
Plug 'jiangmiao/auto-pairs'
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'                " Incremental file and code search
" vim-plug is loaded from the one of the default runtime path.
" If necessary, only upgrade vim-plug itself.
Plug 'junegunn/vim-plug', { 'on': [], 'do': ':PlugUpgrade' }
Plug 'itchyny/lightline.vim'           " Statusline and tabline
Plug 'lifepillar/vim-gruvbox8'         " Color scheme
Plug 'mhinz/vim-signify'               " Show diff to sign column
" vim-themis is a testing framework for vim script.
" Do not load the plugin with vim-plug, use only as a command line tool.
Plug 'thinca/vim-themis', { 'on': [], 'do': 'ln -fsv `pwd`/bin/themis /usr/local/bin/themis' }
Plug 'tpope/vim-endwise'
Plug 'tpope/vim-fugitive'      " git wrapper
" Plug 'prabirshrestha/async.vim', { 'for': 'ruby' }
" Plug 'stackline/vim-asynctags', { 'for': 'ruby' } " Async ctag generator

" --------------------------------------
" LSP
" --------------------------------------
" 1: Neovim built-in LSP
" 2: coc.nvim
let lsp_type = 1

if lsp_type == 1
  Plug 'neovim/nvim-lspconfig'    " Collection of configurations for built-in LSP client
  " NOTE: when using nvim-cmp and neosnippet together, an error occurs.
  Plug 'hrsh7th/nvim-cmp'         " Autocompletion plugin
  Plug 'hrsh7th/cmp-nvim-lsp'     " nvim-cmp source for neovim builtin LSP client
  Plug 'hrsh7th/cmp-buffer'       " nvim-cmp source for buffer words
  Plug 'hrsh7th/cmp-path'         " nvim-cmp source for path
  Plug 'saadparwaiz1/cmp_luasnip' " nvim-cmp source for luasnip
  Plug 'L3MON4D3/LuaSnip'         " Snippets plugin
  Plug 'nvim-lua/lsp-status.nvim'        " for Neovim built-in LSP cleint
  " MEMO: vim-endwise does not work with nvim-treesitter.
  " ref. https://github.com/nvim-treesitter/nvim-treesitter/issues/703
  Plug 'nvim-treesitter/nvim-treesitter', { 'do': ':TSUpdate maintained' } " Highlighting
elseif lsp_type == 2
  Plug 'neoclide/coc.nvim', {'branch': 'release'}
  let s:exts = []
  let s:exts = add(s:exts, 'coc-clangd')     " for c/c++/objective-c, use clangd
  let s:exts = add(s:exts, 'coc-css')        " for css, scss and less
  let s:exts = add(s:exts, 'coc-go')         " for go, use gopls
  let s:exts = add(s:exts, 'coc-json')       " for json
  " The default settings for coc-pairs do not work with smartindent or cindent.
  " When adding settings of following issue, an invalid expression occurred.
  " ref. https://github.com/neoclide/coc-pairs/issues/13
  "
  " let s:exts = add(s:exts, 'coc-pairs')      " auto pair
  let s:exts = add(s:exts, 'coc-snippets')   " snippets
  let s:exts = add(s:exts, 'coc-solargraph') " for ruby, use solargraph
  let s:exts = add(s:exts, 'coc-tsserver')   " for javascript and typescript
  let s:exts = add(s:exts, 'coc-vetur')      " for vue, use vetur
  let s:exts = add(s:exts, 'coc-vimlsp')     " for vim script
  let g:coc_global_extensions = s:exts
  Plug 'neoclide/jsonc.vim'
endif

call plug#end()

" When [!] is included, all found files are sourced.
runtime! plugins/*.vim
if has_key(g:plugs, 'nvim-lspconfig')
  lua require('init')
  lua require('nvim-cmp-config')
  lua require('luasnip-config')
endif

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
" NOTE: Gruvbox8 requires to define "termguicolors = 1" and "background = dark"
" before loading the color scheme.
set termguicolors " Enable true color (24-bit color) in the TUI.
set background=dark
colorscheme gruvbox8

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
set shortmess+=I " Do not display the intro message when starting Vim.
set tabstop=2
set foldlevelstart=99 " [edit] Start editing with no folds closed.
set showtabline=2     " [view] Always show tab line.

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

  " json with comments
  autocmd FileType json set filetype=jsonc
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
  autocmd BufNewFile,BufReadPost Brewfile setfiletype ruby
augroup END

augroup init_bufreadpost_event
  autocmd!

  " When editing a file, always jump to the last cursor position
  autocmd BufReadPost *
        \ if line("'\"") > 0 && line ("'\"") <= line("$") |
        \   exe "normal! g'\"" |
        \ endif
augroup END

" Disable unused default plugins
" let g:did_indent_on             = 1 " Loading indent files for file types.
let g:did_install_default_menus = 1
let g:did_install_syntax_menu   = 1
" let g:did_load_filetypes        = 1 " Detecting file types.
" let g:did_load_ftplugin         = 1 " Loading plugins for file types.
let g:loaded_2html_plugin       = 1
let g:loaded_getscript          = 1
let g:loaded_getscriptPlugin    = 1
let g:loaded_gzip               = 1
let g:loaded_man                = 1
let g:loaded_matchit            = 1
" let g:loaded_matchparen         = 1 " Highlighting matching parens.
let g:loaded_netrw              = 1
let g:loaded_netrwFileHandlers  = 1
let g:loaded_netrwPlugin        = 1
let g:loaded_netrwSettings      = 1
let g:loaded_remote_plugins     = 1
let g:loaded_rrhelper           = 1
let g:loaded_shada_plugin       = 1
let g:loaded_spellfile_plugin   = 1
let g:loaded_tar                = 1
let g:loaded_tarPlugin          = 1
let g:loaded_tutor_mode_plugin  = 1
let g:loaded_vimball            = 1
let g:loaded_vimballPlugin      = 1
let g:loaded_zip                = 1
let g:loaded_zipPlugin          = 1
let g:skip_loading_mswin        = 1

" Disable unused providers
let g:loaded_python3_provider   = 0
let g:loaded_ruby_provider      = 0
let g:loaded_node_provider      = 0
let g:loaded_perl_provider      = 0

" --------------------------------------
" vim-plug
" --------------------------------------
call plug#begin() " Specify default plugin directory: stdpath('data') . '/plugged'

" Color scheme
" ref. https://github.com/termstandard/colors#truecolor-detection
if $COLORTERM ==# 'truecolor'
  Plug 'EdenEast/nightfox.nvim'
endif

" TODO: Stop using ALE plugin if there is no problem with LSP formatting.
" Plug 'dense-analysis/ale'      " linter
Plug 'jiangmiao/auto-pairs'
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'        " incremental file and code search
" vim-plug is loaded from the one of the default runtime path.
" If necessary, only upgrade vim-plug itself.
Plug 'junegunn/vim-plug', { 'on': [], 'do': ':PlugUpgrade' }
Plug 'mhinz/vim-startify'      " Start screen (especially use MRU (Most Recently Used))
Plug 'segeljakt/vim-silicon', { 'on': 'Silicon' } " Source code image generator
Plug 'tpope/vim-fugitive'      " git wrapper

" --------------------------------------
" LSP
" --------------------------------------
Plug 'neovim/nvim-lspconfig'    " Collection of configurations for built-in LSP client
" NOTE: when using nvim-cmp and neosnippet together, an error occurs.
Plug 'hrsh7th/nvim-cmp'         " Autocompletion plugin
Plug 'hrsh7th/cmp-nvim-lsp'     " nvim-cmp source for neovim builtin LSP client
Plug 'hrsh7th/cmp-buffer'       " nvim-cmp source for buffer words
Plug 'hrsh7th/cmp-path'         " nvim-cmp source for path
Plug 'saadparwaiz1/cmp_luasnip' " nvim-cmp source for luasnip
Plug 'L3MON4D3/LuaSnip'         " Snippets plugin
Plug 'mfussenegger/nvim-lint'   " Linter (asynchronous)
Plug 'nvim-treesitter/nvim-treesitter', { 'do': ':TSUpdateSync' } " Highlighting
"
" NOTE: Difference in behavior between nvim-treesitter-endwise and vim-endwise
"
" ### nvim-treesitter-endwise
"
" `end` keyword is added if I enter a class name or method name.
"
"   class Foo
"            ^-- send newline
"   end <-- added
"
" ### vim-endwise
"
" `end` keyword is added even if I don't enter the class name or method name.
"
"   class
"        ^-- send newline
"   end <-- added
"
" ref. https://github.com/nvim-treesitter/nvim-treesitter/issues/703
"
Plug 'RRethy/nvim-treesitter-endwise' " Wisely add 'end' in Ruby, Vimscript, Lua, etc.
Plug 'windwp/nvim-ts-autotag'   " Use treesitter to auto close and auto rename html tag
Plug 'nvim-lualine/lualine.nvim' " Statusline and tabline
Plug 'j-hui/fidget.nvim'         " Standalone UI for nvim-lsp progress
Plug 'lewis6991/gitsigns.nvim'   " Show git diff signs to the signcolumn
Plug 'nvim-tree/nvim-web-devicons' " (required by lualine.nvim, trouble.nvim)
Plug 'onsails/lspkind.nvim'        " (required by nvim-cmp)
Plug 'folke/trouble.nvim'        " Pretty list of diagnostics

call plug#end() " Automatically executes `filetype plugin indent on`

function! PlugIsNotInstalled(plugin_name) abort
  if ! has_key(g:plugs, a:plugin_name)
    return v:true
  endif
  if ! isdirectory(g:plugs[a:plugin_name]['dir'])
    return v:true
  endif

  return v:false
endfunction

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
" Since space is used as prefix in nvim-lspconfig, nothing is done with space alone.
" ref. https://github.com/neovim/nvim-lspconfig#suggested-configuration
nnoremap <Space> <Nop>

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
set formatoptions=tcrqj " Default `tcqj`. Add `r` option (complete comment sign automatically when breaking line)
set tagcase=match " Search a tag file by case match
set expandtab
set shiftwidth=2
set shortmess+=I " Do not display the intro message when starting Vim.
set tabstop=2
set foldlevelstart=99 " [edit] Start editing with no folds closed.
set showtabline=2     " [view] Always show tab line.
set signcolumn=yes
set laststatus=3      " [view] Have a global statusline at the bottom instead of one for each window.
set mouse=            " [edit] Ignore mouse completely
set ambiwidth=single  " [view] Display East Asian Ambiguous Width characters in 1 byte.
" NOTE: Default value of "updatetime" is 4000 ms. It is slow to show
" diagnostic message to floating window with nvim-lspconfig.
set updatetime=300    " Time until CursorHold event of autocommand fires.

" Set the character width to 2
"
" 2192 Rightwards arrow
" 2605 Black star
"
call setcellwidths([
  \ [0x2192, 0x2192, 2],
  \ [0x2605, 0x2605, 2]
  \ ])

" --------------------------------------
" Autocommands
" --------------------------------------
augroup init_vim_autocommands
  autocmd!

  " Delete unnecessary trailing spaces
  autocmd BufWritePre * :%s/\s\+$//ge

  " When editing a file, always jump to the last cursor position
  autocmd BufReadPost *
        \ if line("'\"") > 0 && line ("'\"") <= line("$") |
        \   exe "normal! g'\"" |
        \ endif

  " Open tab pages for each argument.
  "
  " example:
  "   $ vi a.txt b.txt
  "
  "   :tabs
  "   Tab page 1
  "   >   a.txt
  "   Tab page 2
  "   #   b.txt
  "
  " NOTE: Check the number of arguments to avoid an error.
  "
  " * Do not check the number of arguments in the if statement.
  " * Open a file with Neovim and quit immediately.
  " * Confirm that autocmd sometimes fails in the following cases.
  "
  autocmd VimEnter *
        \ if len(argv()) >= 2 |
        \   tab all |
        \ endif
augroup END

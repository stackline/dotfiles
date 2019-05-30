" --------------------------------------
" vim-plug
" --------------------------------------
call plug#begin('~/.local/share/nvim/plugged')

Plug 'w0rp/ale' " linter
Plug 'ludovicchabant/vim-gutentags' " ctags generator
Plug 'tpope/vim-fugitive' " git wrapper
" Plug 'tpope/vim-rails'
" Plug 'joonty/vdebug', { 'rev': 'v1.5.2' }
" Plug 'Shougo/neosnippet.vim'
" Plug 'Shougo/neosnippet-snippets'

" ----------------------------------------
" additional information
" ----------------------------------------
Plug 'airblade/vim-gitgutter' " git diff
Plug 'itchyny/lightline.vim'  " statusline

" ----------------------------------------
" incremental search
" ----------------------------------------
Plug 'ctrlpvim/ctrlp.vim' " file search
Plug 'mileszs/ack.vim'    " code search

" ----------------------------------------
" LSP client
" ----------------------------------------
Plug 'neoclide/coc.nvim', {'tag': '*', 'do': './install.sh'}

" ----------------------------------------
" auto complete
" ----------------------------------------
Plug 'jiangmiao/auto-pairs'
Plug 'tpope/vim-endwise'

" ----------------------------------------
" syntax highlight
" ----------------------------------------
Plug 'morhetz/gruvbox' " color scheme
Plug 'slim-template/vim-slim' " slim

call plug#end()

" --------------------------------------
" ctags
" --------------------------------------
" Show the list when it has many candidates
nnoremap <C-]> g<C-]>
au BufNewFile,BufRead *.php set tags+=~/.cache/ctags/php.tags

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
      \ 'colorscheme': 'gruvbox',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ], [ 'readonly', 'repository', 'relativepath', 'modified' ] ]
      \ },
      \ 'component_function': {
      \   'repository': 'MyRepository'
      \ }
      \ }


" --------------------------------------
" vim-gitgutter
" --------------------------------------
set updatetime=250


" --------------------------------------
" ale
" --------------------------------------
let g:ale_php_phpcs_standard = 'PSR1,PSR2'
let g:ale_php_phpcs_executable = '/usr/bin/phpcs'
" Change rubocop executable from 'rubocop' to 'bundle exec rubocop'
" ref. help ale-ruby-rubocop
let g:ale_ruby_rubocop_executable = 'bundle'


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
colorscheme gruvbox
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

" Enable tag jump to methods with ! or ?
" ref. https://www.reddit.com/r/vim/comments/60el1r/question_jumping_to_tags/
autocmd FileType ruby setlocal iskeyword+=!,?

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


" Delete unnecessary trailing spaces
autocmd BufWritePre * :%s/\s\+$//ge


" --------------------------------------
" coc.nvim
" ref. https://github.com/neoclide/coc.nvim#example-vim-configuration
" --------------------------------------
" if hidden is not set, TextEdit might fail.
set hidden

" Some servers have issues with backup files, see #649
set nobackup
set nowritebackup

" Better display for messages
set cmdheight=2

" Smaller updatetime for CursorHold & CursorHoldI
set updatetime=300

" don't give |ins-completion-menu| messages.
set shortmess+=c

" always show signcolumns
set signcolumn=yes

" Use tab for trigger completion with characters ahead and navigate.
" Use command ':verbose imap <tab>' to make sure tab is not mapped by other plugin.

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()

" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current position.
" Coc only does snippet and additional edit on confirm.

" Use `[c` and `]c` to navigate diagnostics
nmap <silent> [c <Plug>(coc-diagnostic-prev)
nmap <silent> ]c <Plug>(coc-diagnostic-next)

" Remap keys for gotos
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Highlight symbol under cursor on CursorHold
autocmd CursorHold * silent call CocActionAsync('highlight')

" Remap for rename current word
nmap <leader>rn <Plug>(coc-rename)

" Remap for format selected region
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Remap for do codeAction of selected region, ex: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap for do codeAction of current line
nmap <leader>ac  <Plug>(coc-codeaction)
" Fix autofix problem of current line
nmap <leader>qf  <Plug>(coc-fix-current)

" Use `:Format` to format current buffer
command! -nargs=0 Format :call CocAction('format')

" Use `:Fold` to fold current buffer
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" Add diagnostic info for https://github.com/itchyny/lightline.vim
" let g:lightline = {
"       \ 'colorscheme': 'wombat',
"       \ 'active': {
"       \   'left': [ [ 'mode', 'paste' ],
"       \             [ 'cocstatus', 'readonly', 'filename', 'modified' ] ]
"       \ },
"       \ 'component_function': {
"       \   'cocstatus': 'coc#status'
"       \ },
"       \ }

" Using CocList
" Show all diagnostics
nnoremap <silent> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions
nnoremap <silent> <space>e  :<C-u>CocList extensions<cr>
" Show commands
nnoremap <silent> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document
nnoremap <silent> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols
nnoremap <silent> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list
nnoremap <silent> <space>p  :<C-u>CocListResume<CR>


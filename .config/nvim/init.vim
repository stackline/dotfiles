" --------------------------------------
" vim-plug
" --------------------------------------
call plug#begin('~/.local/share/nvim/plugged')

Plug 'w0rp/ale' " linter
Plug 'jsfaint/gen_tags.vim', { 'for': 'ruby' } " Async ctag generator
Plug 'tpope/vim-fugitive' " git wrapper
" Plug 'tpope/vim-rails'
" Plug 'joonty/vdebug', { 'rev': 'v1.5.2' }

" ----------------------------------------
" additional information
" ----------------------------------------
Plug 'airblade/vim-gitgutter' " git diff
Plug 'itchyny/lightline.vim'  " statusline

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
Plug 'morhetz/gruvbox' " color scheme
Plug 'slim-template/vim-slim' " slim

call plug#end()

" --------------------------------------
" gen_tags.vim
" https://github.com/jsfaint/gen_tags.vim
" --------------------------------------
let g:gen_tags#ctags_auto_gen = 1 " enable ctags auto generating
let g:loaded_gentags#ctags    = 0 " enable ctags support
let g:gen_tags#gtags_auto_gen = 0 " disable gtags auto generating
let g:loaded_gentags#gtags    = 1 " disable gtags support
let g:gen_tags#statusline     = 0 " disable to show tags generating info

" --------------------------------------
" ctags
" --------------------------------------
" Show the list when it has many candidates
nnoremap <C-]> g<C-]>
au BufNewFile,BufRead *.php set tags+=~/.cache/ctags/php.tags

" --------------------------------------
" fzf.vim
" https://github.com/junegunn/fzf.vim
" --------------------------------------
nnoremap <C-p> :GFiles<cr>

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
" https://github.com/airblade/vim-gitgutter
" --------------------------------------
set updatetime=250
nmap ]h <Plug>(GitGutterNextHunk)
nmap [h <Plug>(GitGutterPrevHunk)


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
function! GetURLComponents()
  let l:remote_url = system('git remote get-url origin | tr -d "\n"')
  let l:components = split(l:remote_url, "/")

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

" " Better display for messages
" set cmdheight=2

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


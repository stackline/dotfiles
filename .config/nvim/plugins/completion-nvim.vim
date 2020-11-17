" ref. https://github.com/nvim-lua/completion-nvim#configuration
if has_key(g:plugs, 'completion-nvim')
  " Use completion-nvim in every buffer
  autocmd BufEnter * lua require'completion'.on_attach()

  " Use <Tab> and <S-Tab> to navigate through popup menu
  inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
  inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

  " Set completeopt to have a better completion experience
  set completeopt=menuone,noinsert,noselect

  " Avoid showing message extra message when using completion
  set shortmess+=c

  let g:completion_enable_snippet = 'Neosnippet'
  " Use the same key as coc.nvim (default key: <CR>)
  let g:completion_confirm_key = "\<C-y>"
endif

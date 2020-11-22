" ref. https://github.com/nvim-lua/completion-nvim#configuration
if has_key(g:plugs, 'completion-nvim')
  " --------------------------------------------------------
  "  Setup
  " --------------------------------------------------------
  " Use completion-nvim in every buffer
  autocmd BufEnter * lua require'completion'.on_attach()

  " --------------------------------------------------------
  "  Recommended Setting
  " --------------------------------------------------------
  " Use <Tab> and <S-Tab> to navigate through popup menu
  inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
  inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

  " Set completeopt to have a better completion experience
  set completeopt=menuone,noinsert,noselect

  " Avoid showing message extra message when using completion
  set shortmess+=c

  " --------------------------------------------------------
  "  Enable Snippets Support
  " --------------------------------------------------------
  " NOTE: UltiSnips works well. But It spends a little time to start
  " insert mode for the first time.
  let g:completion_enable_snippet = 'Neosnippet'

  " --------------------------------------------------------
  "  Changing Completion Confirm key
  " --------------------------------------------------------
  " Use the same key as coc.nvim (default key: <CR>)
  let g:completion_confirm_key = "\<C-y>"

  " --------------------------------------------------------
  "  Other settings
  " --------------------------------------------------------
  " Prevent text area shift by always displaying the signcolumn.
  " (same setting as coc.nvim)
  set signcolumn=yes
endif

if has_key(g:plugs, 'nvim-lspconfig')
  nnoremap <silent> <c-]> <cmd>lua vim.lsp.buf.definition()<CR>
  nnoremap <silent> K     <cmd>lua vim.lsp.buf.hover()<CR>
  nnoremap <silent> gr    <cmd>lua vim.lsp.buf.references()<CR>
  nnoremap <silent> gd    <cmd>lua vim.lsp.buf.declaration()<CR>
endif

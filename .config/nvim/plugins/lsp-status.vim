if has_key(g:plugs, 'lsp-status.nvim')
  function! LspStatus() abort
    return luaeval("require('lsp-status-wrapper').status()")
  endfunction
endif

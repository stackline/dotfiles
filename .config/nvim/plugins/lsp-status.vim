if has_key(g:plugs, 'lsp-status.nvim')
  " TODO: LspStatus function is a bit slower in the status line dispaly process.
  "       Improve performance later.
  " ref. https://github.com/nvim-lua/lsp-status.nvim#example-use
  function! LspStatus() abort
    if luaeval('#vim.lsp.buf_get_clients() > 0')
      " return luaeval("require('lsp-status').status()")
      let lsp_status = ''

      let lsp_diagnostics = luaeval("require('lsp-status').diagnostics()")
      let lsp_status = lsp_status . ' e ' . lsp_diagnostics['errors']
      let lsp_status = lsp_status . ' w ' . lsp_diagnostics['warnings']

      let lsp_messages = luaeval("require('lsp-status').messages()")
      if len(lsp_messages) >= 1
        let lsp_message = lsp_messages[0]
        let lsp_status = lsp_status . ' | ' . lsp_message['name'] . ': ' . lsp_message['content']
      endif

      return lsp_status
    endif

    return ''
  endfunction
endif

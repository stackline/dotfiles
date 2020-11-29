if has_key(g:plugs, 'nvim-lspconfig')
  " ref. https://neovim.io/doc/user/lsp.html#lsp-config
  nnoremap <silent> <c-]> <cmd>lua vim.lsp.buf.definition()<CR>
  nnoremap <silent> K     <cmd>lua vim.lsp.buf.hover()<CR>
  nnoremap <silent> gr    <cmd>lua vim.lsp.buf.references()<CR>
  nnoremap <silent> gd    <cmd>lua vim.lsp.buf.declaration()<CR>

  augroup nvim_lsp_my_augroup
    autocmd!
    autocmd CursorMoved * call s:CreateDiagnosticMessageDisplayTimer()
  augroup END

  " Initialize
  let s:timer_count = 0
  let s:line = line('.')

  function! s:CreateDiagnosticMessageDisplayTimer()
    " Do nothing when moving columns.
    let s:last_line = s:line
    let s:line = line('.')
    if s:line == s:last_line
      return
    endif

    " Do not over-queue.
    if s:timer_count > 5
      return
    endif
    let s:timer_count = s:timer_count + 1

    call timer_start(100, function('s:DisplayDiagnosticMessage'))
  endfunction

  function! s:DisplayDiagnosticMessage(timer)
    let s:timer_count = s:timer_count - 1
    let diagnostics = luaeval("vim.lsp.diagnostic.get_line_diagnostics()")
    if len(diagnostics) >= 1
      " Specify T flag in the shortmess option to shorten the message.
      echomsg diagnostics[0]['message']
    else
      echo ''
    endif
  endfunction
endif

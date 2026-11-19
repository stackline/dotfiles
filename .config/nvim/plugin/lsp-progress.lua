-- Reusing the token as the message id lets the report and end events update the
-- message that the begin event created.
-- ref. :help LspProgress
vim.api.nvim_create_autocmd('LspProgress', {
  callback = function(ev)
    local value = ev.data.params.value
    vim.api.nvim_echo({ { value.message or 'done' } }, false, {
      id = 'lsp.' .. ev.data.params.token,
      kind = 'progress',
      source = 'vim.lsp',
      title = value.title,
      status = value.kind ~= 'end' and 'running' or 'success',
      percent = value.percentage,
    })

    -- Without a percentage, the built-in handler sends OSC 9;4;1;0, which draws an
    -- empty bar. Override it with the indeterminate state (OSC 9;4;3).
    if value.percentage == nil and value.kind ~= 'end' then
      vim.api.nvim_ui_send('\027]9;4;3\027\\')
    end
  end,
})

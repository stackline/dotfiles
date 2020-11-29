local lsp_status = require('lsp-status')

local function lsp_status_wrapper_status()
  local attached_lsp_client_count = #vim.lsp.buf_get_clients()
  if (attached_lsp_client_count == 0) then
    return ''
  end

  local diagnostics = lsp_status.diagnostics()
  local buffer_status = ' e '..diagnostics['errors']
                      ..' w '..diagnostics['warnings']

  local server_status = ''
  local messages = lsp_status.messages()
  if (#messages >= 1) then
    local message = messages[1]
    server_status = ' | '..message['name']..': '..message['content']
  end

  return buffer_status..server_status
end

local M = {
  status = lsp_status_wrapper_status
}
return M

if vim.fn['PlugIsNotInstalled']('nvim-lint') then
  return
end

------------------------------------------------------------
-- Linter custom configurations
------------------------------------------------------------
local lint = require('lint')

-- Mapping of filetype and linters
lint.linters_by_ft = {
  dockerfile = { 'hadolint' },
  go = { 'staticcheck' },
  ruby = { 'ruby', 'rubocop' },
  sh = { 'shellcheck' },
}

-- staticcheck: Display code in message
local shellcheck = require('lint.linters.shellcheck')
local shellcheck_builtin_parser = shellcheck.parser
shellcheck.parser = function(output)
  diagnostics = shellcheck_builtin_parser(output)
  for i, value in ipairs(diagnostics) do
    diagnostics[i].message = 'SC' .. diagnostics[i].code .. ': ' .. diagnostics[i].message
  end
  return diagnostics
end

------------------------------------------------------------
-- Triggers of linting
------------------------------------------------------------
-- Avoid getting a hit-enter prompt by displaying
-- both nvim-lint run error and autocmd run error.
function try_lint_silently(print_error)
  -- Do not run linter before creating a new file.
  local file_name = vim.api.nvim_buf_get_name(0)
  if vim.fn.filereadable(file_name) == 0 then
    return
  end

  vim.api.nvim_exec(
    "silent! lua require('lint').try_lint()",
    false -- Return empty string if output is false.
  )

  errmsg = vim.api.nvim_get_vvar('errmsg')
  if print_error == true and errmsg ~= '' then
    print(errmsg)
    vim.api.nvim_set_vvar('errmsg', '')
  end
end

vim.cmd("augroup nvim_lint_trigger_of_linting")
vim.cmd("  autocmd!")
-- After writing
vim.cmd("  autocmd BufWritePost * lua try_lint_silently(false)")
-- After displaying the selected file with ctrl-p
vim.cmd("  autocmd BufWinEnter * lua try_lint_silently(true)")
vim.cmd("augroup END")

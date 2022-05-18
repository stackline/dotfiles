if vim.fn['PlugIsNotRegistered']('nvim-lint') then
  return
end

local lint = require('lint')

-- Custom linters
lint.linters.rubocop = {
  cmd = 'rubocop',
  stdin = true,
  args = {'--format', 'json', '--force-exclusion', '--stdin', '%:p'},
  ignore_exitcode = true, -- Rubocop returns 1 as a return code when detecting offenses.
  parser = function(output)
    local diagnostics = {}
    local decoded = vim.json.decode(output)
    local offences = decoded.files[1].offenses

    local sev = vim.diagnostic.severity

    for _, off in pairs(offences or {}) do
      table.insert(diagnostics, {
        lnum = off.location.start_line - 1,
        col = off.location.start_column - 1,
        end_lnum = off.location.last_line - 1,
        end_col = off.location.last_column,
        severity = (off.severity == "error" and sev.ERROR or sev.WARN ),
        message = off.message,
        code = off.cop_name,
        user_data = {
          lsp = {
            code = off.cop_name,
          }
        }
      })
    end

    return diagnostics
  end
}

-- Mapping of filetype and linters
lint.linters_by_ft = {
  dockerfile = { 'hadolint' },
  go = { 'staticcheck' },
  ruby = { 'ruby', 'rubocop' },
}

-- Trigger of linting
vim.cmd("augroup nvim_lint_trigger_of_linting")
vim.cmd("  autocmd!")
-- After writing
vim.cmd("  autocmd BufWritePost * lua require('lint').try_lint()")
-- After displaying the selected file with ctrl-p
vim.cmd("  autocmd BufWinEnter * lua require('lint').try_lint()")
vim.cmd("augroup END")

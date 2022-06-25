if vim.fn['PlugIsNotRegistered']('nvim-lint') then
  return
end

local lint = require('lint')

-- Mapping of filetype and linters
lint.linters_by_ft = {
  dockerfile = { 'hadolint' },
  go = { 'staticcheck' },
  ruby = { 'ruby', 'rubocop' },
  sh = { 'shellcheck' },
}

-- rubocop: Display code in message
local rubocop = require('lint.linters.rubocop')
rubocop.args = {
  '--format',
  'json',
  '--force-exclusion',
  '--display-cop-names', -- Additional parameter
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

-- Trigger of linting
vim.cmd("augroup nvim_lint_trigger_of_linting")
vim.cmd("  autocmd!")
-- After writing
vim.cmd("  autocmd BufWritePost * lua require('lint').try_lint()")
-- After displaying the selected file with ctrl-p
vim.cmd("  autocmd BufWinEnter * lua require('lint').try_lint()")
vim.cmd("augroup END")

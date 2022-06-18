if vim.fn['PlugIsNotRegistered']('nvim-lint') then
  return
end

local lint = require('lint')

-- Mapping of filetype and linters
lint.linters_by_ft = {
  dockerfile = { 'hadolint' },
  go = { 'staticcheck' },
  ruby = { 'ruby', 'rubocop' },
}

local rubocop = require('lint.linters.rubocop')
rubocop.args = {
  '--format',
  'json',
  '--force-exclusion',
  '--display-cop-names', -- Additional parameter
}

-- Trigger of linting
vim.cmd("augroup nvim_lint_trigger_of_linting")
vim.cmd("  autocmd!")
-- After writing
vim.cmd("  autocmd BufWritePost * lua require('lint').try_lint()")
-- After displaying the selected file with ctrl-p
vim.cmd("  autocmd BufWinEnter * lua require('lint').try_lint()")
vim.cmd("augroup END")

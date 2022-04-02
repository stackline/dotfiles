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

-- Customize built-in linter parameters
local staticcheck = require('lint.linters.staticcheck')
staticcheck.stdin = false

-- Mapping of filetype and linters
lint.linters_by_ft = {
  go = { 'staticcheck' },
  ruby = { 'ruby', 'rubocop' },
}

-- Trigger of linting
vim.cmd("augroup nvim_lint_trigger_of_linting")
vim.cmd("  autocmd!")
vim.cmd("  autocmd BufWritePost * lua require('lint').try_lint()")
vim.cmd("augroup END")

-- NOTE: Workaround for Ruby linter
--
-- ### Phenomenon
--
-- * Specify Ruby as linter for Ruby files.
-- * Set autocmd to run nvim-lint's try_lint on BufReadPost.
-- * Open the Ruby file.
-- * Linter is executed, but the check result is not reflected on the screen.
-- * On the other hand, if I execute try_lint on BufWritePost,
--   the check result will be reflected on the screen.
--
-- ### Note about processing
--
-- * In the following process, the character string output by ruby to stderr is displayed in the buffer.
--   * ref. https://github.com/mfussenegger/nvim-lint/blob/8cc31931859dc3cc187fd68509f8649599f72cba/lua/lint.lua#L58
-- * stderr:read_start reads data from stderr stream.
--   * ref. https://github.com/luvit/luv/blob/master/docs.md#uvread_startstream-callback
-- * Pass a callback called read_output to stderr:read_start.
-- * read_output callback doese two things.
--   * concatenates strings with on_chunk.
--   * When the string reaches EOF, it will be displayed in buffer with on_done.
--
-- ### Fact and consideration
--
-- * Fact
--    * Ruby outputs a string to stderr.
--    * Therefore, on_chunk of read_output callback is executed.
--    * However, on_done of read_output callback is not executed.
-- * Consideration
--    * On_done may not be executed because EOF is not included in the string output by Ruby to stderr.
--    * Similar issues. Https://github.com/mfussenegger/nvim-lint/issues/185
--
-- ### Workaround
--
-- * Use a timer to delay the execution timing of try_lint.
-- * ref. https://neovim.io/doc/user/lua.html#E5560
--
local timer = vim.loop.new_timer()
timer:start(1000, 0, vim.schedule_wrap(function()
  lint.try_lint()
end))

local function open_in_github_with_commit_hash()
  ----------------------------------------------------------
  -- Construct the gh browse command
  ----------------------------------------------------------
  -- Get the full path of the current buffer (file)
  local current_file_full_path = vim.api.nvim_buf_get_name(0)

  -- Calculate the relative path from the current working directory
  local relative_path = vim.fn.fnamemodify(current_file_full_path, ":.")
  if relative_path == "" then
    vim.api.nvim_err_writeln("Error: Could not determine relative path.")
    return
  end

  -- Get the latest commit hash for the current file using git log
  local commit_hash = vim.fn.system("git log --pretty=format:\"%h\" -1 " .. vim.fn.fnameescape(relative_path))
  commit_hash = string.gsub(commit_hash, "\n$", "")  -- Remove trailing newline

  if vim.v.shell_error ~= 0 or commit_hash == "" then
    vim.api.nvim_err_writeln("Error getting commit hash for " .. relative_path)
    return
  end

  -- Get the current line number
  local current_line = vim.fn.line(".")

  -- Construct the gh browse command with the commit hash and line number
  local command = "gh browse --commit=" .. commit_hash .. " " .. relative_path .. ":" .. current_line

  ----------------------------------------------------------
  -- Execute the gh browse command
  ----------------------------------------------------------
  local result = vim.fn.system(command)

  -- Check for errors
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_err_writeln("Error executing gh browse: " .. result)
  else
    print("Opened " .. relative_path .. " in GitHub (commit " .. commit_hash .. ", line " .. current_line .. ").")
  end
end

vim.api.nvim_create_user_command('OpenInGitHubCommit', open_in_github_with_commit_hash, {})
vim.api.nvim_set_keymap('n', '<leader>gh', ':OpenInGitHubCommit<CR>', { noremap = true, silent = true })

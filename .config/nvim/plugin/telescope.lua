local ok, telescope = pcall(require, 'telescope')
if not ok then
  print('telescope.nvim is not loaded.')
  return
end

telescope.setup {
  defaults = {
    sorting_strategy = 'ascending', -- default: descending
    layout_config = {
      horizontal = {
        height = 0.9,
        preview_cutoff = 10,     -- default: 120, Don't cutoff preview window.
        prompt_position = "top", -- default: bottom
        width = 0.8
      },
    },
  },
  pickers = {
    git_files = {
      -- The default value of git_command is as follows.
      -- ref: git_command = {"git", "ls-files", "--exclude-standard", "--cached"}
      --
      --   --exclude-standard  Exclude files according to the settings in the gitignore file.
      --   --cached            Show cached files in the output.
      --   --others            Show other files (i.e. untracked files) in the output.
      --
      show_untracked = true -- default: false, Add "--others" flag to git_command.
    },
  },
}

-- TODO: Set cword as initial value with live_grep.
-- TODO: Open the selection in a new tab.
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<C-p>', builtin.git_files, {})
vim.keymap.set('n', '<C-j>', builtin.live_grep, {})


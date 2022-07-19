-- NOTE: Limited to repository, not workspace.
-- ref. https://code.visualstudio.com/docs/editor/workspaces#_workspace-settings

-- Make a rough judgement by referring to the judgement of the git command.
-- ref. https://github.com/git/git/blob/v2.37.1/setup.c#L330-L341
local function is_git_dir(dir)
  local objects_dir_exists = vim.fn.isdirectory(dir .. '/.git/objects')
  local refs_dir_exists = vim.fn.isdirectory(dir .. '/.git/refs')
  local head_file_exists = vim.fn.filereadable(dir .. '/.git/HEAD')

  if (objects_dir_exists ~= 0 and refs_dir_exists ~= 0 and head_file_exists ~= 0) then
    return true
  else
    return false
  end
end

local function find_git_top_level_dir(target_dir)
  if target_dir == nil then
    return ''
  end

  if is_git_dir(target_dir) then
    return target_dir
  else
    local above_dir = string.match(target_dir, "([^\n]+)/.+")
    return find_git_top_level_dir(above_dir)
  end
end

local function load_repo_setting_file()
  local cwd = vim.fn.getcwd()

  local git_top_level_dir = find_git_top_level_dir(cwd)
  if git_top_level_dir == '' then
    -- TODO: Add display control for verbose messages.
    -- print("repo-setting: not a git repository")
    return
  end

  local setting_file_path = git_top_level_dir .. '/.nvim/init.lua'
  if vim.fn.filereadable(setting_file_path) == 0 then
    -- print("repo-setting: Setting file does not exist")
    return
  end

  dofile(setting_file_path)
end

load_repo_setting_file()

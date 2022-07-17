local function git_rev_parse_is_executable()
  local exit_status = os.execute("git rev-parse")
  if exit_status == 0 then
    return true
  else
    return false
  end
end

local function build_repo_setting_file_path()
  local handle = io.popen("git rev-parse --show-toplevel")
  local result = handle:read("a")
  handle:close()

  local repo_toplevel_dir = result:gsub("\n*", "")
  local repo_setting_file_path = repo_toplevel_dir .. "/.nvim/init.lua"

  return repo_setting_file_path
end

local function file_exists(filename)
  local handle = io.open(filename, "r")
  if handle ~= nil then
    handle.close()
    return true
  else
    return false
  end
end

-- TODO: Add display control for verbose messages.
-- ref. https://code.visualstudio.com/docs/editor/workspaces#_workspace-settings
local function load_repo_setting_file()
  if git_rev_parse_is_executable() == false then
    -- print("repo-setting: git rev-parse is not executable.")
    return
  end

  local repo_setting_file_path = build_repo_setting_file_path()

  if file_exists(repo_setting_file_path) == false then
    -- print("repo-setting: Setting file does not exist.")
    return
  end

  dofile(repo_setting_file_path)
end

load_repo_setting_file()

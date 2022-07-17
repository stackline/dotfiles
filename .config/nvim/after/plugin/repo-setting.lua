local function file_exists(filename)
  local handle = io.open(filename, "r")
  if handle ~= nil then
    handle.close()
    return true
  else
    return false
  end
end

-- ref. https://code.visualstudio.com/docs/editor/workspaces#_workspace-settings
local function load_repo_setting()
  local handle = io.popen("git rev-parse --show-toplevel")
  local result = handle:read("a")
  handle:close()

  local repo_toplevel_dir = result:gsub("\n*", "")
  local repo_setting = repo_toplevel_dir .. "/.nvim/init.lua"

  if (file_exists(repo_setting)) then
    dofile(repo_setting)
  end
end

load_repo_setting()

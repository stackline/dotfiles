------------------------------------------------------------
-- bookmarks.lua
------------------------------------------------------------
-- A tiny file-bookmark feature: one global list, shared across every
-- repository, persisted as git-root-relative paths. The same bookmark therefore
-- jumps to the matching file in whichever repository you're currently in (handy
-- for a repo cloned several times under different directory names).
--
-- Storage (~/.local/share/nvim/bookmarks.json) — lists are keyed by "scope":
--   { "version": 1, "scopes": { "global": [ { "path": "models/.../foo.sql", "line": 57 } ] } }
-- Today there is a single "global" scope. To manage bookmarks per repository in
-- the future, make scope_key() return something repo-specific (e.g. git_root());
-- the format already keys lists by scope, so no data migration is needed.
--
-- Keymaps:
--   <leader>b   toggle the bookmark on the current file (add / remove)
--   <leader>h   open the bookmark list (also :Bookmarks; alpha's button)
--   <leader>1-9 jump directly to bookmark N
-- List (fzf): type to filter, <CR> to open, ctrl-d to delete, ctrl-v (g:fzf_action)
-- to open in a new tab.

local M = {}

local data_file = vim.fs.joinpath(vim.fn.stdpath("data"), "bookmarks.json")

-- Git root of the current buffer, falling back to the cwd (e.g. on the start
-- screen, where the buffer has no file). Relative paths are resolved against it.
local function git_root()
  return vim.fs.root(0, ".git") or vim.uv.cwd()
end

-- Which bookmark list to use. A single global list for now; switch this to a
-- repo-specific value to get per-repository lists later.
local function scope_key()
  return "global"
end

local function load()
  local data = { version = 1, scopes = {} }
  local f = io.open(data_file, "r")
  if f then
    local content = f:read("*a")
    f:close()
    local ok, decoded = pcall(vim.json.decode, content)
    if ok and type(decoded) == "table" and type(decoded.scopes) == "table" then
      data = decoded
    end
  end
  return data
end

local function save(data)
  local f, err = io.open(data_file, "w")
  if not f then
    vim.notify("Bookmarks: cannot write " .. data_file .. ": " .. tostring(err), vim.log.levels.ERROR)
    return
  end
  f:write(vim.json.encode(data))
  f:close()
end

-- The bookmark list for the current scope (created on demand).
local function get_list(data)
  local key = scope_key()
  data.scopes[key] = data.scopes[key] or {}
  return data.scopes[key]
end

-- Path of the current buffer relative to its git root (nil for an unnamed
-- buffer). Paths outside the root are kept as-is.
local function current_relpath()
  local file = vim.api.nvim_buf_get_name(0)
  if file == "" then
    return nil
  end
  file = vim.fs.normalize(file)
  local root = git_root()
  if root and vim.startswith(file, root .. "/") then
    return file:sub(#root + 2)
  end
  return file
end

function M.toggle()
  local rel = current_relpath()
  if not rel then
    vim.notify("Bookmarks: no file in the current buffer", vim.log.levels.WARN)
    return
  end
  local data = load()
  local list = get_list(data)
  for i, b in ipairs(list) do
    if b.path == rel then
      table.remove(list, i)
      save(data)
      vim.notify("Bookmark removed: " .. rel)
      return
    end
  end
  table.insert(list, { path = rel, line = vim.api.nvim_win_get_cursor(0)[1] })
  save(data)
  vim.notify("Bookmark added: " .. rel)
end

-- Open bookmark N in the current repository: join its relative path onto the
-- current git root, then restore the saved cursor line.
function M.open(index)
  local b = get_list(load())[index]
  if not b then
    return
  end
  vim.cmd.edit(vim.fn.fnameescape(vim.fs.joinpath(git_root(), b.path)))
  if b.line then
    pcall(vim.api.nvim_win_set_cursor, 0, { b.line, 0 })
  end
end

-- Pick a bookmark with fzf. The keys in g:fzf_action (e.g. ctrl-v: tab split)
-- work as in the other fzf lists; ctrl-d deletes the highlighted bookmark and
-- reopens the refreshed list.
function M.list()
  local bookmarks = get_list(load())
  if #bookmarks == 0 then
    vim.notify("Bookmarks: no bookmarks")
    return
  end

  -- Keep the number in each entry so it still matches <leader>N and can be typed
  -- into the fzf query.
  local source = {}
  for i, b in ipairs(bookmarks) do
    source[i] = string.format("%d  %s", i, b.path)
  end

  local actions = vim.g.fzf_action or {}
  local expect = vim.tbl_keys(actions)
  table.insert(expect, "ctrl-d")

  local function on_select(lines)
    -- With --expect the first line is the pressed key ("" for <CR>) and the
    -- second is the selected entry; <Esc> / <C-c> leave no entry.
    local key, entry = lines[1], lines[2]
    local idx = entry and tonumber(entry:match("^(%d+)"))
    if not idx then
      return
    end
    if key == "ctrl-d" then
      local data = load()
      table.remove(get_list(data), idx)
      save(data)
      M.list()
      return
    end
    if type(actions[key]) == "string" then
      vim.cmd(actions[key])
    end
    M.open(idx)
  end

  vim.fn["fzf#run"](vim.fn["fzf#wrap"]("bookmarks", {
    source = source,
    ["sink*"] = on_select,
    options = {
      "--prompt=Bookmarks> ",
      "--tiebreak=index",
      "--expect=" .. table.concat(expect, ","),
    },
  }))
end

------------------------------------------------------------
-- Commands & keymaps
------------------------------------------------------------
vim.api.nvim_create_user_command("Bookmarks", M.list, { desc = "Open the bookmark list" })

vim.keymap.set("n", "<leader>b", M.toggle, { desc = "Bookmark: toggle file" })
vim.keymap.set("n", "<leader>h", M.list, { desc = "Bookmark: list" })
for i = 1, 9 do
  vim.keymap.set("n", "<leader>" .. i, function() M.open(i) end, { desc = "Bookmark " .. i })
end

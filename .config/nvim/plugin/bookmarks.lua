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
-- List window: <CR> or 1-9 to open, dd to delete, q / <Esc> to close.

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

function M.list()
  local bookmarks = get_list(load())

  local lines = {}
  if #bookmarks == 0 then
    lines = { "  (no bookmarks)" }
  else
    for i, b in ipairs(bookmarks) do
      lines[i] = string.format(" %d  %s", i, b.path)
    end
  end

  local width = 40
  for _, l in ipairs(lines) do
    width = math.max(width, vim.fn.strdisplaywidth(l) + 2)
  end
  local height = #lines

  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  vim.bo[buf].modifiable = false
  vim.bo[buf].bufhidden = "wipe"

  local win = vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    width = width,
    height = math.max(height, 1),
    row = math.floor((vim.o.lines - height) / 2 - 1),
    col = math.floor((vim.o.columns - width) / 2),
    style = "minimal",
    border = "rounded",
    title = " bookmarks ",
    title_pos = "center",
  })
  vim.wo[win].cursorline = true

  local function close()
    if vim.api.nvim_win_is_valid(win) then
      vim.api.nvim_win_close(win, true)
    end
  end

  local opts = { buffer = buf, nowait = true, silent = true }

  vim.keymap.set("n", "<CR>", function()
    local idx = vim.api.nvim_win_get_cursor(win)[1]
    if bookmarks[idx] then
      close()
      M.open(idx)
    end
  end, opts)

  for i = 1, math.min(9, #bookmarks) do
    vim.keymap.set("n", tostring(i), function()
      close()
      M.open(i)
    end, opts)
  end

  -- dd: delete the bookmark on the current line, then reopen the refreshed list.
  vim.keymap.set("n", "dd", function()
    local idx = vim.api.nvim_win_get_cursor(win)[1]
    if not bookmarks[idx] then
      return
    end
    local data = load()
    table.remove(get_list(data), idx)
    save(data)
    close()
    M.list()
  end, opts)

  -- Buffer-local C-n/C-p navigation, overriding the global <C-p> (fzf) mapping
  -- while this window is focused.
  vim.keymap.set("n", "<C-n>", "j", opts)
  vim.keymap.set("n", "<C-p>", "k", opts)

  vim.keymap.set("n", "q", close, opts)
  vim.keymap.set("n", "<Esc>", close, opts)
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

local ok, lualine = pcall(require, 'lualine')
if not ok then
  print('lualine.nvim is not loaded.')
  return
end

local function find_git_root(dir)
  if dir == nil then
    return ""
  end

  -- NOTE: "isdirectory() ~= 0" means that "isdirectory"" function don't return
  -- false. In other words, the target path exists and is a directory.
  if vim.fn.isdirectory(dir .. "/.git") ~= 0 then
    return dir
  else
    -- NOTE: "string.match" return nil if the argument "s" doesn't match the
    -- argument "pattern".
    local parent_dir = string.match(dir, "([^\n]+)/.+")
    return find_git_root(parent_dir)
  end
end

local function split(str, sep)
  local pattern = "%s"
  if sep ~= nil then
    pattern = "([^" .. sep .. "]+)"
  end

  local t = {}
  for word in string.gmatch(str, pattern) do
    table.insert(t, word)
  end
  return t
end

local function buf_get_filename(self)
  if self.filename == '' then
    return '[No Name]'
  end

  -- NOTE: How to get the relative path
  --
  -- "self.filename" is the value of vim.api.nvim_buf_get_name(0).
  --
  --   ex) /foo/bar/repository_root/baz/hoge.txt
  --
  -- "self.git_root_path" is the parent directory of .git directory.
  --
  --   ex) /foo/bar/repository_root
  --
  -- Cut from "#self.git_root_path + 2" to the end of the path.
  --
  --   ex) /foo/bar/repository_root/baz/hoge.txt
  --                              ^ ^
  --                              | |
  --                              | #self.git_root_path + 2
  --                              |
  --                              #self.git_root_path
  --
  local relative_path = string.sub(self.filename, #self.git_root_path + 2)
  return relative_path
end

local function buf_get_repository_name(self)
  if self.git_root_path == '' then
    return ''
  end

  -- Get a file handle of git config.
  local git_config_path = self.git_root_path .. '/.git/config'
  local file_handle = io.open(git_config_path, 'r')
  if file_handle == nil then
    return ''
  end

  -- Parse git config.
  local t = {}
  local section
  for line in file_handle:lines() do
    local matched = string.match(line, "^%[(.+)%]$")

    if matched ~= nil then
      section = matched
      t[section] = {}
    else
      local element = split(line, '=')
      local name = element[1]:gsub(" ", ""):gsub("\t", "")
      local value = element[2]:gsub(" ", ""):gsub("\t", "")
      t[section][name] = value
    end
  end
  file_handle:close()

  -- Extract repository name.
  local remote_repository_url = t['remote "origin"']['url']
  local url_parts = split(remote_repository_url, '/')
  local end_of_path = url_parts[#url_parts]
  local path_parts = split(end_of_path, '.')
  local repository_name = path_parts[1]

  return repository_name
end

local function buf_get_branch_name(self)
  if self.git_root_path == '' then
    return ''
  end

  -- Get a file handle of git config.
  local git_head_path = self.git_root_path .. '/.git/HEAD'
  local file_handle = io.open(git_head_path, 'r')
  if file_handle == nil then
    return ''
  end
  local head_info = file_handle:read("l")
  file_handle:close()

  -- Parse git HEAD.
  --
  -- ### Format of HEAD file
  --
  -- HEAD refers to a specific branch => ref: refs/heads/any_branch_name
  -- HEAD refers to a specific commit => any_commit_hash
  --
  local refer_to_branch = (head_info:match("^ref: ") ~= nil)

  if refer_to_branch then
    local head_parts = split(head_info, ":")
    local head_ref = head_parts[2]
    local head_ref_parts = split(head_ref, "/")
    local branch_name = head_ref_parts[#head_ref_parts]
    return branch_name
  else
    local commit_hash = head_info:sub(1,7)
    return commit_hash
  end
end

local function init(buf_filename)
  local obj = {}
  obj.filename = buf_filename
  obj.git_root_path = find_git_root(buf_filename)
  obj.buf_get_filename = buf_get_filename
  obj.buf_get_repository_name = buf_get_repository_name
  obj.buf_get_branch_name = buf_get_branch_name
  return obj
end

local M = { init = init }

-- Run once after reading a file to a buffer.
local group_id = vim.api.nvim_create_augroup('MyLuaLineGroup', {})
vim.api.nvim_create_autocmd({ 'BufNewFile', 'BufReadPost' }, {
  group = group_id,
  pattern = { "*" },
  callback = function()
    local m = M.init(vim.api.nvim_buf_get_name(0))
    local bufnr = vim.api.nvim_get_current_buf()
    -- NOTE: Passing an extra argument "self" by using the colon operator.
    -- ref. https://www.lua.org/pil/16.html
    vim.b[bufnr].buf_filename = m:buf_get_filename()
    -- NOTE: If I want to display the repository name, uncomment this line.
    -- vim.b[bufnr].buf_repository = m:buf_get_repository_name()
    vim.b[bufnr].buf_branch = m:buf_get_branch_name()
  end
})

local nvim_web_devicons = require 'nvim-web-devicons'

-- ref. Default configuration
-- https://github.com/nvim-lualine/lualine.nvim#default-configuration
lualine.setup {
  sections = {
    -- Default: lualine_b = {'branch', 'diff', 'diagnostics'},
    lualine_b = { 'b:buf_branch', 'b:lsp_mode', 'diagnostics' },
    lualine_c = { 'b:buf_filename' },
  },
  tabline = {
    lualine_a = {
      {
        'tabs',
        -- NOTE: Override "max_length" option to avoid omitting the file name of
        -- tab component.
        max_length = vim.o.columns,
        mode = 2,
        -- NOTE: Perhaps the tabline color scheme changed in the commit below,
        -- so I specified a color close to the color before the commit.
        --
        -- ref. https://github.com/EdenEast/nightfox.nvim/commit/9df01a3fb3d41e1e388ded7a34fe97a19146a283
        tabs_color = {
          active   = { fg = '#131a24', bg = '#719cd6' },
          inactive = { fg = '#131a24', bg = '#71839b' },
        },

        -- ref. https://github.com/nvim-lualine/lualine.nvim#tabs-component-options
        fmt = function(name, context)
          -- Show the icon if an icon exists for the given file.
          -- NOTE: The third argument is a setting to return the default icon
          -- if there is no matching icon.
          local icon = nvim_web_devicons.get_icon(name, nil, { default = true })

          -- Show + if buffer is modified in tab.
          local buflist = vim.fn.tabpagebuflist(context.tabnr)
          local winnr = vim.fn.tabpagewinnr(context.tabnr)
          local bufnr = buflist[winnr]
          local mod = vim.fn.getbufvar(bufnr, '&mod')

          return icon .. ' ' .. name .. (mod == 1 and ' +' or '')
        end
      },
    },
    lualine_b = {},
    lualine_c = {},
    lualine_x = {},
    lualine_y = {},
    lualine_z = {},
  },
  -- winbar = {},
  -- inactive_winbar = {},
}

-- lspsaga.nvim displays breadcrumbs on the winbar,
-- so lualine doesn't display anything on the winbar.
-- ref: https://github.com/nvim-lualine/lualine.nvim?tab=readme-ov-file#disabling-lualine
lualine.hide({
  place = {'winbar'},
  unhide = false,
})

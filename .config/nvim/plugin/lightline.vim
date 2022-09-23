if PlugIsNotInstalled('lightline.vim')
  finish
endif

" NOTE: Display LSP status and the file name as much as possible
" with the "%<" symbol.
" ref. https://github.com/itchyny/lightline.vim#how-can-i-truncate-the-components-from-the-right-in-narrow-windows
"
" NOTE: BufEnter event does not occurs when opening the filer.
" Use 'get' function to avoid variable undeclared errors.
let g:lightline = {
    \ 'colorscheme': 'nightfox',
    \ 'active': {
    \   'left': [ [ 'mode', 'paste' ],
    \             [ 'lspstatus', 'readonly', 'file', 'modified' ] ],
    \   'right': [ [ 'lineinfo-with-virtual-column-number' ],
    \              [ 'percent' ],
    \              [ 'fileformat', 'fileencoding', 'filetype' ] ]
    \ },
    \ 'tabline': {
    \   'right': [ [ 'git_info' ] ]
    \ },
    \ 'component': {
    \   'lineinfo-with-virtual-column-number': '%3l:%-2v',
    \   'git_info': '%{get(b:, "statusline_git_info", "")}',
    \   'file': '%{get(b:, "statusline_file_name", "")}%<'
    \ },
    \ 'component_function': {
    \   'lspstatus': 'StatusLineLspStatus'
    \ },
    \ }

" NOTE: Prevent the display positon of tabs from shifting when moving to
" another tab.
"
" left:  Separator sign of selected tabs of left part
" right: Unknown
let lightline.tabline_separator = { 'left': ' ', 'right': ' ' }
" left:  Separator sign of unselected tabs of left part
" right: Separator sign of repository name and branch name of right part
let lightline.tabline_subseparator = { 'left': '|', 'right': '|' }

augroup statusline_cache_items
  autocmd!
  " NOTE: vim-fugitive sets `b:git_dir` variable at BufReadPost event.
  autocmd BufEnter * call StatusLineCacheItems()
augroup END

function! StatusLineCacheItems()
  let b:statusline_git_info = luaeval('StatusLineGitInfo()')
  let b:statusline_file_name = luaeval('StatusLineFileName()')
endfunction

function! StatusLineLspStatus()
  if has_key(g:plugs, 'lsp-status.nvim')
    " The value that the status function return includes half-width space on
    " the right side. Trim the extra right space off.
    return trim(luaeval("require('lsp-status').status()"))
  else
    return ''
  endif
endfunction

lua << EOF
  local function find_git_root(dir)
    if dir == nil then
      return ""
    end

    if vim.fn.isdirectory(dir .. "/.git") ~= 0 then
      return dir
    else
      local parent_dir = string.match(dir, "([^\n]+)/.+")
      return find_git_root(parent_dir)
    end
  end

  local function split(str, sep)
    pattern = "%s"
    if sep ~= nil then
      pattern = "([^" .. sep .. "]+)"
    end

    local t = {}
    for word in string.gmatch(str, pattern) do
      table.insert(t, word)
    end
    return t
  end

  function StatusLineGitInfo()
    -- Extract git root path
    local buf_file_path = vim.api.nvim_buf_get_name(0)
    if buf_file_path == '' then
      return ''
    end

    local git_root_path
    if vim.b.cached_git_root ~= nil then
      git_root_path = vim.b.cached_git_root
    else
      git_root_path = find_git_root(buf_file_path)
      vim.b.cached_git_root = git_root_path
    end

    -- Extract repository name
    local git_config_path = git_root_path .. '/.git/config'
    local t = {}

    local f = io.open(git_config_path, 'r')
    local section
    for line in f:lines() do
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
    f:close()

    local remote_repository_url = t['remote "origin"']['url']
    local url_parts = split(remote_repository_url, '/')
    local end_of_path = url_parts[#url_parts]
    local path_parts = split(end_of_path, '.')
    local repository_name = path_parts[1]

    -- Extract branch name
    local head_file_path = git_root_path .. '/.git/HEAD'
    local f = io.open(head_file_path, 'r')
    local head = f:read('a')
    local branch_name = head:gsub('ref: refs/heads/', ''):gsub("\n", '')

    return repository_name .. ' | ' .. branch_name
  end

  function StatusLineFileName()
    local buf_file_path = vim.api.nvim_buf_get_name(0)
    if buf_file_path == '' then
      return ''
    end

    local git_root_path
    if vim.b.cached_git_root ~= nil then
      git_root_path = vim.b.cached_git_root
    else
      git_root_path = find_git_root(buf_file_path)
      vim.b.cached_git_root = git_root_path
    end

    local git_root_relative_path = buf_file_path:gsub(git_root_path, ''):gsub("^/", '')
    return git_root_relative_path
  end
EOF

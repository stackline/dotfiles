local ok, nightfox = pcall(require, 'nightfox')
if not ok then
  print('nightfox.nvim is not loaded.')
  return
end

-- ref. https://github.com/EdenEast/nightfox.nvim#customize-palettes-and-groups
local groups = {
  all = {
    -- Make the color of the window separator line easier to see.
    -- ref. https://github.com/EdenEast/nightfox.nvim/blob/e2f961859cbfb2ba38147dc59fdd2314992c8b62/lua/nightfox/group/editor.lua#L26
    VertSplit = { fg = 'palette.blue' },
  },
}
nightfox.setup({ groups = groups })

vim.cmd("colorscheme nightfox")

local ok, nightfox = pcall(require, 'nightfox')
if not ok then
  print('nightfox.nvim is not loaded.')
  return
end

local palettes = {
  -- Make comments easier to read.
  -- ref. https://www.colorhexa.com/738091
  nightfox = {
    comment = "#9ea7b3", -- default: #738091
  },
  carbonfox = {
    comment = "#9ea7b3", -- default: #738091
  },
}

-- ref. https://github.com/EdenEast/nightfox.nvim#customize-palettes-and-groups
local groups = {
  all = {
    -- Make the color of the window separator line easier to see.
    -- ref. https://github.com/EdenEast/nightfox.nvim/blob/e2f961859cbfb2ba38147dc59fdd2314992c8b62/lua/nightfox/group/editor.lua#L26
    VertSplit = { fg = 'palette.blue' },
    -- Specify the same color as the background color of NormalFloat.
    -- "bg0" is darker bg.
    FloatBorder = { bg = 'palette.bg0' },
  },
}

nightfox.setup({ palettes = palettes, groups = groups })

vim.cmd("colorscheme carbonfox")

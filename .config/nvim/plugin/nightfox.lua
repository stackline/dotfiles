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
    WinSeparator = { fg = 'palette.blue' },
  },
}

nightfox.setup({ palettes = palettes, groups = groups })

vim.cmd("colorscheme carbonfox")

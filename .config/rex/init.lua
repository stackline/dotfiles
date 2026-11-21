----------------------------------------
-- Pane
----------------------------------------
-- Split pane
rex.bind("ctrl+t>shift+5", "pane.split", { direction = "right" })
rex.bind("ctrl+t>shift+'", "pane.split", { direction = "down" })

-- Switch pane
rex.bind("ctrl+t>ctrl+t", "pane.focus_next")
rex.bind("ctrl+t>h", "pane.focus", { direction = "left" })
rex.bind("ctrl+t>j", "pane.focus", { direction = "down" })
rex.bind("ctrl+t>k", "pane.focus", { direction = "up" })
rex.bind("ctrl+t>l", "pane.focus", { direction = "right" })

-- Resize pane
rex.bind("ctrl+t>shift+h", "pane.resize", { amount = 5, direction = "left" })
rex.bind("ctrl+t>shift+j", "pane.resize", { amount = 5, direction = "down" })
rex.bind("ctrl+t>shift+k", "pane.resize", { amount = 5, direction = "up" })
rex.bind("ctrl+t>shift+l", "pane.resize", { amount = 5, direction = "right" })

-- Copy mode
rex.bind("ctrl+t>[", "pane.copy_mode.enter")

----------------------------------------
-- Tab
----------------------------------------
-- Create tab
rex.bind("ctrl+t>c", "client.tab.new")

-- Switch tab
rex.bind("ctrl+t>n", "client.tab.next")
rex.bind("ctrl+t>p", "client.tab.previous")

-- Go to tab (default: cmd + <number>)
local BASE = 1
for i = 0, 9 do
  rex.bind("ctrl+t>" .. i, "client.tab.goto", { index = i + BASE })
end

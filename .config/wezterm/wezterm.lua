local wezterm = require 'wezterm'

return {
  color_scheme = 'Monokai (base16)',
  -- NOTE: I want to display only the cursor in the active pane. However,
  -- when I click the leader key, the cursors for all panes are displayed.
  --
  -- The compose_cursor option changes the cursor color when inputting with IME
  -- in addition to clicking the leader key.
  --
  --   colors = {
  --       compose_cursor = "black",
  --   },
  --
  -- Stop blinking cursor to reduce battery consumption.
  cursor_blink_rate = 0,
  -- NOTE: Use "Illusion N" font when displaying characters with
  -- the East Asian Ambiguous Width characteristic.
  --
  --   font = wezterm.font("Illusion N"),
  --
  font = wezterm.font("Source Han Code JP"),
  font_size = 12.0,
  hide_tab_bar_if_only_one_tab = true,
  treat_east_asian_ambiguous_width_as_wide = false,

  keys = {
    -- Disable the default action "CloseCurrentTab" to avoid terminating wezterm
    -- with one click.
    { key = "w", mods = "CMD", action = wezterm.action.DisableDefaultAssignment },
  }

  -- Similar to tmux prefix key.
  -- leader = { key="t", mods="CTRL", timeout_milliseconds=1000 },
  -- keys = {
  --   -- Select to rectangle.
  --   --   option + mouse move

  --   -- Split current pane.
  --   { key="%",  mods="LEADER", action=wezterm.action{SplitHorizontal={domain="CurrentPaneDomain"}}},
  --   { key="\"", mods="LEADER", action=wezterm.action{SplitVertical={domain="CurrentPaneDomain"}}},

  --   -- Activate an adjacent pane (with vim-like key bindings).
  --   { key="h", mods="LEADER", action=wezterm.action{ActivatePaneDirection="Left"}},
  --   { key="l", mods="LEADER", action=wezterm.action{ActivatePaneDirection="Right"}},
  --   { key="k", mods="LEADER", action=wezterm.action{ActivatePaneDirection="Up"}},
  --   { key="j", mods="LEADER", action=wezterm.action{ActivatePaneDirection="Down"}},
  --   { key="t", mods="LEADER|CTRL", action=wezterm.action{ActivatePaneDirection="Next"}},

  --   -- Activate a specific tab.
  --   -- TODO: Rewrite in a loop.
  --   { key=tostring(1), mods="LEADER", action=wezterm.action{ActivateTab=0}, },
  --   { key=tostring(2), mods="LEADER", action=wezterm.action{ActivateTab=1}, },
  --   { key=tostring(3), mods="LEADER", action=wezterm.action{ActivateTab=2}, },
  --   { key=tostring(4), mods="LEADER", action=wezterm.action{ActivateTab=3}, },
  --   { key=tostring(5), mods="LEADER", action=wezterm.action{ActivateTab=4}, },
  --   { key="n", mods="LEADER", action=wezterm.action{ActivateTabRelative=1}},

  --   -- Create a new tab.
  --   { key="c", mods="LEADER", action=wezterm.action{SpawnTab="CurrentPaneDomain"}},

  --   -- Scroll by page.
  --   { key="UpArrow", mods="SHIFT", action=wezterm.action{ScrollByPage=-1}},
  --   { key="DownArrow", mods="SHIFT", action=wezterm.action{ScrollByPage=1}},
  -- }
}

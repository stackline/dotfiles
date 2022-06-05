local wezterm = require 'wezterm'

return {
  color_scheme = "Tomorrow Night",
  font = wezterm.font("Source Han Code JP"),
  font_size = 13.0,
  -- Make it clearer which is the active pane.
  inactive_pane_hsb = {
    saturation = 0.5,
    brightness = 0.5,
  },
  treat_east_asian_ambiguous_width_as_wide = true,

  -- Similar to tmux prefix key.
  leader = { key="t", mods="CTRL", timeout_milliseconds=1000 },
  keys = {
    -- Select to rectangle.
    --   option + mouse move

    -- Split current pane.
    { key="%",  mods="LEADER", action=wezterm.action{SplitHorizontal={domain="CurrentPaneDomain"}}},
    { key="\"", mods="LEADER", action=wezterm.action{SplitVertical={domain="CurrentPaneDomain"}}},

    -- Activate an adjacent pane (with vim-like key bindings).
    { key="h", mods="LEADER", action=wezterm.action{ActivatePaneDirection="Left"}},
    { key="l", mods="LEADER", action=wezterm.action{ActivatePaneDirection="Right"}},
    { key="k", mods="LEADER", action=wezterm.action{ActivatePaneDirection="Up"}},
    { key="j", mods="LEADER", action=wezterm.action{ActivatePaneDirection="Down"}},
    { key="t", mods="LEADER|CTRL", action=wezterm.action{ActivatePaneDirection="Next"}},

    -- Activate a specific tab.
    -- TODO: Rewrite in a loop.
    { key=tostring(1), mods="LEADER", action=wezterm.action{ActivateTab=0}, },
    { key=tostring(2), mods="LEADER", action=wezterm.action{ActivateTab=1}, },
    { key=tostring(3), mods="LEADER", action=wezterm.action{ActivateTab=2}, },
    { key=tostring(4), mods="LEADER", action=wezterm.action{ActivateTab=3}, },
    { key=tostring(5), mods="LEADER", action=wezterm.action{ActivateTab=4}, },
    { key="n", mods="LEADER", action=wezterm.action{ActivateTabRelative=1}},

    -- Create a new tab.
    { key="c", mods="LEADER", action=wezterm.action{SpawnTab="CurrentPaneDomain"}},

    -- Scroll by page.
    { key="UpArrow", mods="SHIFT", action=wezterm.action{ScrollByPage=-1}},
    { key="DownArrow", mods="SHIFT", action=wezterm.action{ScrollByPage=1}},
  }
}

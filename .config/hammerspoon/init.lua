-- Show the current audio output device in the menu bar.
local output_menu = hs.menubar.new()

local function update_output_title()
  local device = hs.audiodevice.defaultOutputDevice()
  output_menu:setTitle(device and device:name() or "no output")
end

-- Fires on any audio configuration change (device added or removed, default output switched).
hs.audiodevice.watcher.setCallback(update_output_title)
hs.audiodevice.watcher.start()

update_output_title()

require("hs.ipc") -- enables `hs -c` CLI for debugging

-- Dim unfocused windows/screens when AeroSpace focus changes
hs.window.highlight.ui.overlay = true
hs.window.highlight.ui.overlayColor = { 0, 0, 0, 0.3 }
hs.window.highlight.ui.frameWidth = 0
hs.window.highlight.start()

-- Dark mode when external monitor connected; otherwise light during the day, dark at night
local DAY_START, DAY_END = 7, 19 -- ponytail: fixed hours, swap for hs.location sunrise/sunset if precision matters

local function setDarkMode(dark)
  hs.osascript.applescript(([[
    tell application "System Events" to tell appearance preferences to set dark mode to %s
  ]]):format(dark and "true" or "false"))
end

local function updateAppearance()
  local externalConnected = #hs.screen.allScreens() > 1
  if externalConnected then
    setDarkMode(true)
  else
    local hour = tonumber(os.date("%H"))
    setDarkMode(not (hour >= DAY_START and hour < DAY_END))
  end
end

updateAppearance()
appearanceScreenWatcher = hs.screen.watcher.new(updateAppearance):start()
appearanceTimer = hs.timer.doEvery(1800, updateAppearance)

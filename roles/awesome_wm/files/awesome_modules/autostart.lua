local awful = require("awful") -- Standard awesome library

local function autostart()
  -- Applets
  awful.spawn.with_shell("nm-applet")
  awful.spawn.with_shell("kill $(pgrep pa-applet --exact); pa-applet --disable-notifications")
  awful.spawn.with_shell("blueman-applet")
  awful.spawn.with_shell("kill $(pgrep syncthingtray --exact); syncthingtray")
  awful.spawn.with_shell("kdeconnect-indicator")

  -- Others
  awful.spawn.with_shell("libinput-gestures-setup start")
  awful.spawn.with_shell("xautolock -time 10 -locker \"/usr/bin/lockscreen\"")
  awful.spawn.with_shell("picom")
end

return {
  autostart = autostart
}

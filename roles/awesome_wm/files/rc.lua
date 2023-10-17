local darguima_wibar = require("darguima-wibar")
local error_handling = require("awesome_modules/error_handling").error_handling
local set_wallpaper = require("awesome_modules/set_wallpaper").set_wallpaper
local bindings = require("awesome_modules/bindings")
local rules = require("awesome_modules/rules")
local signals = require("awesome_modules/signals")
local autostart = require("awesome_modules/autostart").autostart

-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")

local beautiful = require("beautiful") -- Theme handling library
local awful = require("awful")         -- Standard awesome library
require("awful.autofocus")
-- Enable hotkeys help widget for VIM and other apps
-- when client with a matching name is opened:
require("awful.hotkeys_popup.keys")

-- Handle AwesomeWM startup errors
error_handling()

-- {{{ Variable definitions
beautiful.init(os.getenv("HOME") .. "/.config/awesome/themes/darguima-theme/theme.lua")
-- beautiful.init(require("gears").filesystem.get_themes_dir() .. "default/theme.lua")

terminal = "alacritty"
editor = os.getenv("EDITOR") or "vim"
editor_cmd = terminal .. " -e " .. editor
modkey = "Mod4"
-- }}}

-- Table of layouts
awful.layout.layouts = {
    awful.layout.suit.corner.nw,
    awful.layout.suit.floating,
    awful.layout.suit.tile,
}

-- Adding Wallpaper and Wibar to all screens
awful.screen.connect_for_each_screen(function(s)
    set_wallpaper(beautiful, s)

    -- Create a wibar for each screen and add it
    darguima_wibar.create(s, beautiful)
end)

-- Keys and Mouse bindings
root.buttons(bindings.mouse_bindings())
root.keys(bindings.global_keys(modkey))

-- Clients Rules
rules.rules(beautiful, bindings.client_keys(modkey))

-- Screens & Clients Signals
signals.screen_signals()
signals.clients_signals(beautiful)

-- Start at boot apps & applets
autostart()

-- Debug:
-- require("naughty").notify({
--     title = "Debugging",
--     text = tostring(screen.centerwibar.x)
-- })

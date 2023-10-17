local gears = require("gears")
local awful = require("awful")
local hotkeys_popup = require("awful.hotkeys_popup")

local function global_keys(modkey)
  local globalkeys = gears.table.join(
  -- {{{ My bindings
    awful.key({ modkey, }, "f", function() awful.spawn("firefox") end,
      { description = "open firefox", group = "launcher" }),
    awful.key({ modkey, }, "d", function() awful.spawn("rofi -show run"); end,
      { description = "rofi", group = "launcher" }),
    awful.key({ modkey, "Control" }, "l", function() awful.spawn("lockscreen") end,
      { description = "Lock Screen", group = "System" }),
    awful.key({ modkey, "Control" }, "s", function()
        awful.spawn("lockscreen"); awful.spawn("systemctl suspend")
      end,
      { description = "Suspend", group = "System" }),
    -- }}}

    awful.key({ modkey, }, "s", hotkeys_popup.show_help,
      { description = "show help", group = "awesome" }),
    awful.key({ modkey, }, "Left", awful.tag.viewprev,
      { description = "view previous", group = "tag" }),
    awful.key({ modkey, }, "Right", awful.tag.viewnext,
      { description = "view next", group = "tag" }),
    awful.key({ modkey, }, "Escape", awful.tag.history.restore,
      { description = "go back", group = "tag" }),

    -- Choose task
    awful.key({ modkey, }, "k", function() awful.client.focus.byidx(1) end,
      { description = "focus next by index", group = "client" }),
    awful.key({ modkey, }, "j", function() awful.client.focus.byidx(-1) end,
      { description = "focus previous by index", group = "client" }),
    awful.key({ modkey, }, "u", awful.client.urgent.jumpto,
      { description = "jump to urgent client", group = "client" }),


    -- Layout manipulation
    awful.key({ modkey, }, "l", function() awful.tag.incmwfact(0.05) end,
      { description = "increase master width factor", group = "layout" }),
    awful.key({ modkey, }, "h", function() awful.tag.incmwfact(-0.05) end,
      { description = "decrease master width factor", group = "layout" }),
    awful.key({ modkey, "Shift" }, "k", function() awful.client.swap.byidx(1) end,
      { description = "swap with next client by index", group = "client" }),
    awful.key({ modkey, "Shift" }, "j", function() awful.client.swap.byidx(-1) end,
      { description = "swap with previous client by index", group = "client" }),
    awful.key({ modkey, "Control" }, "k", function() awful.screen.focus_relative(1) end,
      { description = "focus the next screen", group = "screen" }),
    awful.key({ modkey, "Control" }, "j", function() awful.screen.focus_relative(-1) end,
      { description = "focus the previous screen", group = "screen" }),

    awful.key({ modkey, }, "Tab",
      function()
        awful.client.focus.history.previous()
        if client.focus then
          client.focus:raise()
        end
      end,
      { description = "go back", group = "client" }),

    -- Standard program
    awful.key({ modkey, }, "Return", function() awful.spawn(terminal) end,
      { description = "open a terminal", group = "launcher" }),
    awful.key({ modkey, "Control" }, "r", awesome.restart,
      { description = "reload awesome", group = "awesome" }),
    awful.key({ modkey, "Shift" }, "q", awesome.quit,
      { description = "quit awesome", group = "awesome" }),
    awful.key({ modkey, }, "space", function() awful.layout.inc(1) end,
      { description = "select next", group = "layout" }),
    awful.key({ modkey, "Shift" }, "space", function() awful.layout.inc(-1) end,
      { description = "select previous", group = "layout" }),

    awful.key({ modkey, "Control" }, "n",
      function()
        local c = awful.client.restore()
        -- Focus restored client
        if c then
          c:emit_signal(
            "request::activate", "key.unminimize", { raise = true }
          )
        end
      end,
      { description = "restore minimized", group = "client" }),

    -- Prompt
    awful.key({ modkey }, "r", function() awful.screen.focused().mypromptbox:run() end,
      { description = "run prompt", group = "launcher" }),

    awful.key({ modkey }, "x",
      function()
        awful.prompt.run {
          prompt       = "Run Lua code: ",
          textbox      = awful.screen.focused().mypromptbox.widget,
          exe_callback = awful.util.eval,
          history_path = awful.util.get_cache_dir() .. "/history_eval"
        }
      end,
      { description = "lua execute prompt", group = "awesome" })
  )

  -- Bind all key numbers to tags.
  -- Be careful: we use keycodes to make it work on any keyboard layout.
  -- This should map on the top row of your keyboard, usually 1 to 9.
  for i = 1, 6 do
    globalkeys = gears.table.join(globalkeys,
      -- View tag only.
      awful.key({ modkey }, "#" .. i + 9,
        function()
          local screen = awful.screen.focused()
          local tag = screen.tags[i]
          if tag then
            tag:view_only()
          end
        end,
        { description = "view tag #" .. i, group = "tag" }),

      -- Move client to tag.
      awful.key({ modkey, "Shift" }, "#" .. i + 9,
        function()
          if client.focus then
            local tag = client.focus.screen.tags[i]
            if tag then
              client.focus:move_to_tag(tag)
            end
          end
        end,
        { description = "move focused client to tag #" .. i, group = "tag" }),

      -- Toggle tag on focused client.
      awful.key({ modkey, "Control" }, "#" .. i + 9,
        function()
          if client.focus then
            local tag = client.focus.screen.tags[i]
            if tag then
              client.focus:toggle_tag(tag)
            end
          end
        end,
        { description = "toggle focused client on tag #" .. i, group = "tag" })
    )
  end

  return globalkeys
end

local function client_keys(modkey)
  return gears.table.join(
    awful.key({ modkey, "Control" }, "f",
      function(c)
        c.fullscreen = not c.fullscreen
        c:raise()
      end,
      { description = "toggle fullscreen", group = "client" }),
    awful.key({ modkey }, "q", function(c) c:kill() end,
      { description = "close", group = "client" }),
    awful.key({ modkey, "Control" }, "space", awful.client.floating.toggle,
      { description = "toggle floating", group = "client" }),
    awful.key({ modkey, }, "o", function(c) c:move_to_screen() end,
      { description = "move to screen", group = "client" }),
    awful.key({ modkey, }, "t", function(c) c.ontop = not c.ontop end,
      { description = "toggle keep on top", group = "client" }),

    awful.key({ modkey, }, "n",
      function(c)
        -- The client currently has the input focus, so it cannot be
        -- minimized, since minimized clients can't have the focus.
        c.minimized = true
      end,
      { description = "minimize", group = "client" }),

    awful.key({ modkey, }, "m",
      function(c)
        c.maximized = not c.maximized
        c:raise()
      end,
      { description = "(un)maximize", group = "client" })
  )
end

local function mouse_bindings()
  return gears.table.join(
    awful.button({}, 3, function()
      -- write on this function what you want that happens on right mouse click
    end),
    awful.button({}, 4, awful.tag.viewnext),
    awful.button({}, 5, awful.tag.viewprev)
  )
end

return {
  global_keys = global_keys,
  client_keys = client_keys,
  mouse_bindings = mouse_bindings,
}

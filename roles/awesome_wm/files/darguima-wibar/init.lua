-- dotfiles_environment = `desktop`, `laptop` or ...
-- Why? In `desktop`, for example, isn't needed to load battery or brightness widgtes.
local DotfilesEnvironment = require("awesome_modules/dotfiles").get_dotfiles_environment()

local awful = require("awful")
local dpi = require("beautiful.xresources").apply_dpi
local wibox = require("wibox")
local gears = require("gears")

-- https://awesomewm.org/doc/api/classes/wibox.html

-- Taglist Mouse events
local taglist_buttons = gears.table.join(
  awful.button({}, 1, function(t) t:view_only() end)
)

-- Tasklist Mouse events
local tasklist_buttons = gears.table.join(

  awful.button({}, 1, function(c)
    c:emit_signal(
      "request::activate",
      "tasklist",
      { raise = true }
    )
  end),

  awful.button({}, 3, function()
    awful.menu.client_list()
  end)
)

local function add_widgets_to_wibox(screen)
  if DotfilesEnvironment == "laptop" then
    BatteryWidget = require("battery-widget") {}
    BrightnessWidget = require("brightness")({ backend = "xbacklight" }).widget
  end

  -- Each screen has its own tag table.
  awful.tag({ "1", "2", "3", "4", "5", "6" }, screen, awful.layout.layouts[1])
  -- Create a taglist widget
  screen.mytaglist = awful.widget.taglist {
    screen  = screen,
    filter  = awful.widget.taglist.filter.all,
    buttons = taglist_buttons
  }

  -- Create a promptbox for each screen
  screen.mypromptbox = awful.widget.prompt()

  -- Create an imagebox widget which will contain an icon indicating which layout we're using.
  screen.mylayoutbox = awful.widget.layoutbox(screen)

  -- Create a tasklist widget
  screen.mytasklist = awful.widget.tasklist {
    screen  = screen,
    filter  = awful.widget.tasklist.filter.currenttags,
    buttons = tasklist_buttons,

    layout  = {
      spacing_widget = {
        {
          forced_width  = 5,
          forced_height = 24,
          thickness     = 1,
          color         = '#777777',
          widget        = wibox.widget.separator
        },
        valign = 'center',
        halign = 'center',
        widget = wibox.container.place,
      },
      spacing        = 1,
      layout         = wibox.layout.fixed.horizontal,
    },

  }

  screen.leftwibar:setup {
    layout = wibox.layout.align.horizontal,
    {
      layout = wibox.layout.fixed.horizontal,
      screen.mytaglist,
      screen.mypromptbox,
    }
  }

  screen.centerwibar:setup {
    layout = wibox.layout.align.horizontal,
    nil,
    screen.mytasklist,
  }

  screen.rightwibar:setup {
    layout = wibox.layout.align.horizontal,
    nil,
    {
      layout = wibox.layout.fixed.horizontal,
      wibox.widget.systray(),
      BatteryWidget,
      BrightnessWidget,
    },
    {
      layout = wibox.layout.fixed.horizontal,
      wibox.widget.textclock(),
      screen.mylayoutbox,
    },
  }

  return screen
end

local function create(screen, theme)
  local margin = {
    x = 24,
    y = 4
  }

  local height = dpi(20)

  screen.leftwibar = wibox({
    width = screen.geometry.width * 0.1,
    height = height,

    x = screen.geometry.x + margin.x,
    y = screen.geometry.y + margin.y,

    ontop = true,
    visible = true,

    screen = screen,
  })

  screen.centerwibar = wibox({
    width = screen.geometry.width * 0.7 - margin.x * 4,
    height = height,

    x = screen.leftwibar.x + screen.leftwibar.width + margin.x,
    y = screen.leftwibar.y,

    ontop = true,
    visible = true,

    screen = screen,
  })

  screen.rightwibar = wibox({
    width = screen.geometry.width * 0.2,
    height = height,

    x = screen.centerwibar.x + screen.centerwibar.width + margin.x,
    y = screen.centerwibar.y,

    ontop = true,
    visible = true,

    screen = screen,
  })

  screen = add_widgets_to_wibox(screen)

  screen.padding = {
    top = screen.centerwibar.y + screen.centerwibar.height, -- + useless_gap of the client
  }

  return screen
end

return {
  create = create,
}

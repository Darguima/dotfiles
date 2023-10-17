------------------------------
-- "Darguima" awesome theme --
--  By Dário G. (darguima)  --
------------------------------

-- https://awesomewm.org/doc/api/libraries/beautiful.html
-- https://awesomewm.org/doc/api/classes/awful.widget.tasklist.html

local dpi                                       = require("beautiful.xresources").apply_dpi

local theme                                     = {}
theme.confdir                                   = os.getenv("HOME") .. "/.config/awesome/themes/darguima-theme"
theme.wallpaper                                 = theme.confdir .. "/darguima-background.png"
theme.awesome_icon                              = theme.confdir .. "/icons/awesome-icon.png"
theme.font                                      = "sans 8"
theme.menu_bg_normal                            = "#000000"
theme.menu_bg_focus                             = "#000000"
theme.bg_normal                                 = "#3F3F3F"
theme.bg_focus                                  = "#1E2320"
theme.bg_urgent                                 = "#3F3F3F"
theme.bg_systray                                = theme.bg_normal
theme.fg_normal                                 = "#DCDCCC"
theme.fg_focus                                  = "#F0DFAF"
theme.fg_urgent                                 = "#CC9393"
theme.fg_minimize                               = "#ffffff"
theme.border_width                              = dpi(2)
theme.border_normal                             = "#3F3F3F"
theme.border_focus                              = "#6F6F6F"
theme.border_marked                             = "#CC9393"
theme.titlebar_bg_focus                         = "#3F3F3F"
theme.titlebar_bg_normal                        = "#3F3F3F"
theme.menu_border_width                         = 0
theme.menu_width                                = dpi(250)
theme.menu_height                               = dpi(15)
theme.menu_submenu_icon                         = theme.confdir .. "/icons/submenu.png"
theme.menu_fg_normal                            = "#aaaaaa"
theme.menu_fg_focus                             = "#ff8c00"
theme.menu_bg_normal                            = "#050505dd"
theme.menu_bg_focus                             = "#050505dd"
theme.widget_temp                               = theme.confdir .. "/icons/temp.png"
theme.widget_uptime                             = theme.confdir .. "/icons/ac.png"
theme.widget_cpu                                = theme.confdir .. "/icons/cpu.png"
theme.widget_weather                            = theme.confdir .. "/icons/dish.png"
theme.widget_fs                                 = theme.confdir .. "/icons/fs.png"
theme.widget_mem                                = theme.confdir .. "/icons/mem.png"
theme.widget_note                               = theme.confdir .. "/icons/note.png"
theme.widget_note_on                            = theme.confdir .. "/icons/note_on.png"
theme.widget_netdown                            = theme.confdir .. "/icons/net_down.png"
theme.widget_netup                              = theme.confdir .. "/icons/net_up.png"
theme.widget_mail                               = theme.confdir .. "/icons/mail.png"
theme.widget_batt                               = theme.confdir .. "/icons/bat.png"
theme.widget_clock                              = theme.confdir .. "/icons/clock.png"
theme.widget_vol                                = theme.confdir .. "/icons/spkr.png"
theme.taglist_squares_sel                       = theme.confdir .. "/icons/taglist/squarefz.png"
theme.taglist_squares_unsel                     = theme.confdir .. "/icons/taglist/squarez.png"
theme.tasklist_plain_task_name                  = false
theme.tasklist_disable_icon                     = false
theme.tasklist_disable_task_name                = true
theme.useless_gap                               = dpi(2)
-- Layouts Icons
theme.layout_tile                               = theme.confdir .. "/icons/layouts/tile.png"
theme.layout_tileleft                           = theme.confdir .. "/icons/layouts/tileleft.png"
theme.layout_tilebottom                         = theme.confdir .. "/icons/layouts/tilebottom.png"
theme.layout_tiletop                            = theme.confdir .. "/icons/layouts/tiletop.png"
theme.layout_fairv                              = theme.confdir .. "/icons/layouts/fairv.png"
theme.layout_fairh                              = theme.confdir .. "/icons/layouts/fairh.png"
theme.layout_spiral                             = theme.confdir .. "/icons/layouts/spiral.png"
theme.layout_dwindle                            = theme.confdir .. "/icons/layouts/dwindle.png"
theme.layout_max                                = theme.confdir .. "/icons/layouts/max.png"
theme.layout_fullscreen                         = theme.confdir .. "/icons/layouts/fullscreen.png"
theme.layout_magnifier                          = theme.confdir .. "/icons/layouts/magnifier.png"
theme.layout_floating                           = theme.confdir .. "/icons/layouts/floating.png"
theme.layout_cornernw                           = theme.confdir .. "/icons/layouts/cornernw.png"
theme.layout_cornerne                           = theme.confdir .. "/icons/layouts/cornerne.png"
theme.layout_cornersw                           = theme.confdir .. "/icons/layouts/cornersw.png"
theme.layout_cornerse                           = theme.confdir .. "/icons/layouts/cornerse.png"
-- Title Bar Icons
theme.titlebar_close_button_focus               = theme.confdir .. "titlebar/close_focus.png"
theme.titlebar_close_button_normal              = theme.confdir .. "titlebar/close_normal.png"
theme.titlebar_minimize_button_normal           = theme.confdir .. "titlebar/minimize_normal.png"
theme.titlebar_minimize_button_focus            = theme.confdir .. "titlebar/minimize_focus.png"
theme.titlebar_ontop_button_focus_active        = theme.confdir .. "titlebar/ontop_focus_active.png"
theme.titlebar_ontop_button_normal_active       = theme.confdir .. "titlebar/ontop_normal_active.png"
theme.titlebar_ontop_button_focus_inactive      = theme.confdir .. "titlebar/ontop_focus_inactive.png"
theme.titlebar_ontop_button_normal_inactive     = theme.confdir .. "titlebar/ontop_normal_inactive.png"
theme.titlebar_sticky_button_focus_active       = theme.confdir .. "titlebar/sticky_focus_active.png"
theme.titlebar_sticky_button_normal_active      = theme.confdir .. "titlebar/sticky_normal_active.png"
theme.titlebar_sticky_button_focus_inactive     = theme.confdir .. "titlebar/sticky_focus_inactive.png"
theme.titlebar_sticky_button_normal_inactive    = theme.confdir .. "titlebar/sticky_normal_inactive.png"
theme.titlebar_floating_button_focus_active     = theme.confdir .. "titlebar/floating_focus_active.png"
theme.titlebar_floating_button_normal_active    = theme.confdir .. "titlebar/floating_normal_active.png"
theme.titlebar_floating_button_focus_inactive   = theme.confdir .. "titlebar/floating_focus_inactive.png"
theme.titlebar_floating_button_normal_inactive  = theme.confdir .. "titlebar/floating_normal_inactive.png"
theme.titlebar_maximized_button_focus_active    = theme.confdir .. "titlebar/maximized_focus_active.png"
theme.titlebar_maximized_button_normal_active   = theme.confdir .. "titlebar/maximized_normal_active.png"
theme.titlebar_maximized_button_focus_inactive  = theme.confdir .. "titlebar/maximized_focus_inactive.png"
theme.titlebar_maximized_button_normal_inactive = theme.confdir .. "titlebar/maximized_normal_inactive.png"

-- There are other variable sets

-- [taglist|tasklist]_[bg|fg]_[focus|urgent|occupied|empty|volatile]
-- titlebar_[normal|focus]
-- tooltip_[font|opacity|fg_color|bg_color|border_width|border_color]
-- menu_[bg|fg]_[normal|focus]
-- menu_[border_color|border_width]

-- Example:
--theme.taglist_bg_focus = "#CC9393"

return theme

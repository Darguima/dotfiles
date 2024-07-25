# Electron Apps
export MOZ_ENABLE_WAYLAND=1

# https://wiki.archlinux.org/title/Wayland#GUI_libraries

# GTK
export GDK_BACKEND='wayland' # confirm

# QT
export QT_QPA_PLATFORM="wayland;xcb"

# Clutter
export CLUTTER_BACKEND='wayland'

# SDL2
export SDL_VIDEODRIVER="wayland,x11"

# GLFW
export XDG_SESSION_TYPE='wayland'

# EFL
export ELM_DISPLAY='wl'

# Electron
export ELECTRON_OZONE_PLATFORM_HINT='auto'
export OZONE_PLATFORM='wayland'
export ENABLE_FEATURES="UseOzonePlatform,WaylandWindowDecorations,WebRTCPipeWireCapturer" 

# Java (workaround for blank screen)
# export _JAVA_AWT_WM_NONREPARENTING=1
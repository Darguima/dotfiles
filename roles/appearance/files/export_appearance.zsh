# Wayland
export QT_QPA_PLATFORM="wayland;xcb"
export GDK_BACKEND=wayland
export CLUTTER_BACKEND=wayland
export OZONE_PLATFORM=wayland
export XDG_SESSION_TYPE=wayland
export CLUTTER_BACKEND=wayland
export SDL_VIDEODRIVER="wayland,x11"
export XDG_SESSION_TYPE=wayland

# QT
export QT_QPA_PLATFORMTHEME=qt6ct

# GTK
export GTK2_RC_FILES="$HOME/.gtkrc-2.0"

# Dark Mode
export GTK_THEME=Adwaita:dark

# VS Code

# Electron Apps
export MOZ_ENABLE_WAYLAND=1
export ELECTRON_OZONE_PLATFORM_HINT=auto
export ENABLE_FEATURES="UseOzonePlatform,WaylandWindowDecorations" 
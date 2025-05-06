# GLOBAL ALIASES

alias _="sudo"
alias l="ls -la"
alias la="ls -la"

alias c="clear"
alias co="code ."

alias upgrade="yay -Suy --devel --noconfirm"
alias clean_yay='sudo pacman -Scc --noconfirm && yay -Scc --noconfirm && orphans=$(pacman -Qdtq) && [ -n "$orphans" ] && sudo pacman -Rns $orphans --noconfirm || echo "No orphan packages to remove."'

# DroidCam
# alias init_mic0="pactl load-module module-alsa-source device=hw:0,1,0"
# alias init_mic1="pactl load-module module-alsa-source device=hw:0,1,1"
# alias kill_mics="pactl unload-module module-alsa-source"
# alias init_cam="echo \"vm\" | env ANDROID_SERIAL=A3201809023158 droidcam-cli -a -v -dev=/dev/video0 adb 4747"
# alias mic_test="LBID=$(pactl load-module module-loopback); sleep 1; pactl unload-module $LBID"
# GLOBAL ALIASES

alias _="sudo"
alias la="ls -la"
alias keyMouse="setxkbmap -option keypad:pointerkeys"

alias init_mic0="pacmd load-module module-alsa-source device=hw:Loopback,1,0"
alias init_mic1="pacmd load-module module-alsa-source device=hw:Loopback,1,1"
alias kill_mics="pacmd unload-module module-alsa-source"
alias init_cam="echo \"vm\" | env ANDROID_SERIAL=A3201809023158 droidcam-cli -a -v -dev=/dev/video0 adb 4747"
# alias mic_test="LBID=$(pactl load-module module-loopback); sleep 1; pactl unload-module $LBID"

# To get the sink name > pacmd list-sinks
alias changeToHeadphones="pacmd set-sink-port alsa_output.pci-0000_09_00.4.analog-stereo analog-output-headphones"
alias changeToSpeakers="pacmd set-sink-port alsa_output.pci-0000_09_00.4.analog-stereo analog-output-lineout"

alias dotfiles="$DOTFILES/install"
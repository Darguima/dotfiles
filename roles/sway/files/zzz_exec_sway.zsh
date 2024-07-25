if [[ -z $DISPLAY ]] && [[ $(tty) = /dev/tty1 ]] && command -v sway &> /dev/null; then

	export XDG_CURRENT_DESKTOP=sway

	exec sway --unsupported-gpu

fi

include () {
  [[ -r "$1" ]] && source "$1"
}

include "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
include $HOME/.p10k.zsh
include $HOME/.asdf/asdf.sh
include /usr/share/z/z.sh

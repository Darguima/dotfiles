# GLOBAL ALIASES

alias _="sudo"
alias l="ls -la"
alias la="ls -la"

alias c="clear"
alias co="code ."

alias upgrade="yay -Suyy --devel --noconfirm"
alias clean_yay='sudo pacman -Scc --noconfirm && yay -Scc --noconfirm && orphans=$(pacman -Qtdq); [ -n "$orphans" ] && sudo pacman -Rns $(pacman -Qdtq) --noconfirm || echo "No pacman orphans"; orphans=$(yay -Qtdq); [ -n "$orphans" ] && yay -Rns $(yay -Qtdq) --noconfirm || echo "No yay orphans"'

# Docker aliases
alias docker='docker'
alias dls='docker container ls --all --format "table {{.ID}}\t{{.Names}}\t{{.CreatedAt}}\t{{.Status}}"'
alias dc='docker container'
alias di='docker image'
alias dv='docker volume'
alias dn='docker network'
alias dprune='docker system prune --all --force'

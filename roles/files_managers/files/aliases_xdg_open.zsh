# I know, it's not an alias, but it's a function that I use as an alias

open() {
  xdg-open "$@"  & disown
}

o() {
  xdg-open "$@" & disown
}

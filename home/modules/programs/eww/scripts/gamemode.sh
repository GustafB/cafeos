#!/usr/bin/env bash
# Game mode: strips Hyprland eye-candy (animations/blur/shadows) for FPS.
# Adapted from gh0stzk/dotfiles; hyprland-native, restores explicitly.

cache_dir="${XDG_CACHE_HOME:-$HOME/.cache}/cafeos"
cache_file="$cache_dir/gamemode_state"
mkdir -p "$cache_dir"
[ -f "$cache_file" ] || echo "Off" >"$cache_file"

get_state() { head -n1 "$cache_file" 2>/dev/null || echo "Off"; }

# "true"/"false" for the eww active class.
state() { case "$(get_state)" in On) echo true ;; *) echo false ;; esac; }

on() {
  hyprctl --batch "\
    keyword animations:enabled 0;\
    keyword decoration:blur:enabled 0;\
    keyword decoration:shadow:enabled 0" >/dev/null 2>&1
  echo "On" >"$cache_file"
  hyprctl notify 5 2000 "rgb(9ece6a)" "Game mode on — eye-candy disabled"
}

off() {
  hyprctl --batch "\
    keyword animations:enabled 1;\
    keyword decoration:blur:enabled 1;\
    keyword decoration:shadow:enabled 1" >/dev/null 2>&1
  echo "Off" >"$cache_file"
  hyprctl notify 5 2000 "rgb(7aa2f7)" "Game mode off"
}

toggle() { if [ "$(get_state)" = "Off" ]; then on; else off; fi; }

case "$1" in
  --state)  state ;;
  --status) get_state ;;
  --toggle) toggle ;;
  *) echo "usage: $0 [--state|--status|--toggle]" ;;
esac

#!/usr/bin/env bash
# Airplane mode: kills networking (and bluetooth), remembers prior BT state.
# Adapted from gh0stzk/dotfiles for hyprland/NixOS.

cache_dir="${XDG_CACHE_HOME:-$HOME/.cache}/cafeos"
cache_file="$cache_dir/airplane_state"
mkdir -p "$cache_dir"
[ -f "$cache_file" ] || echo "Off" >"$cache_file"

has_bluetooth() {
  rfkill list bluetooth >/dev/null 2>&1 || return 1
  systemctl is-active bluetooth >/dev/null 2>&1
}

get_state() { head -n1 "$cache_file" 2>/dev/null || echo "Off"; }

icon() { case "$(get_state)" in On) echo "󰀝" ;; *) echo "󰀞" ;; esac; }

# "true" when airplane mode is engaged (drives the active class).
state() { case "$(get_state)" in On) echo true ;; *) echo false ;; esac; }

on() {
  nmcli networking off
  if has_bluetooth; then
    bt=$(bluetoothctl show 2>/dev/null | grep -q "Powered: yes" && echo On || echo Off)
    [ "$bt" = "On" ] && bluetoothctl power off >/dev/null 2>&1
    printf "On\n%s" "$bt" >"$cache_file"
  else
    echo "On" >"$cache_file"
  fi
  hyprctl notify 5 2000 "rgb(7aa2f7)" "Airplane mode on"
}

off() {
  nmcli networking on
  if has_bluetooth; then
    prev=$(sed -n '2p' "$cache_file" 2>/dev/null)
    [ "$prev" = "On" ] && bluetoothctl power on >/dev/null 2>&1
  fi
  echo "Off" >"$cache_file"
  hyprctl notify 5 2000 "rgb(7aa2f7)" "Airplane mode off"
}

toggle() { if [ "$(get_state)" = "Off" ]; then on; else off; fi; }

case "$1" in
  --icon)   icon ;;
  --state)  state ;;
  --status) get_state ;;
  --toggle) toggle ;;
  *) echo "usage: $0 [--icon|--state|--status|--toggle]" ;;
esac

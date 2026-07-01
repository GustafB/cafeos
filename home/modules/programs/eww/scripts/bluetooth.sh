#!/usr/bin/env bash
# Bluetooth state + toggle for the eww control center.
# Adapted from gh0stzk/dotfiles for hyprland/NixOS (hyprctl notify, no dunst).

has_bluetooth() {
  rfkill list bluetooth >/dev/null 2>&1 || return 1
  systemctl is-active bluetooth >/dev/null 2>&1
}

powered() { bluetoothctl show 2>/dev/null | grep -q "Powered: yes"; }

icon() {
  if has_bluetooth && powered; then echo "󰂯"; else echo "󰂲"; fi
}

# Connected device name(s), or On/Off/Null status.
name() {
  if ! has_bluetooth; then echo "Null"; return; fi
  if powered; then
    dev=$(bluetoothctl info 2>/dev/null | grep "Name" | sed 's/^\s*Name: //')
    if [ -n "$dev" ]; then
      echo "$dev" | awk '{s = s $0 ", "} END {sub(", $", "", s); print s}'
    else
      echo "On"
    fi
  else
    echo "Off"
  fi
}

# "true" when powered on (drives the active class in eww).
state() { if has_bluetooth && powered; then echo true; else echo false; fi; }

toggle() {
  if ! has_bluetooth; then
    hyprctl notify -1 4000 "rgb(f7768e)" "Bluetooth unavailable or service inactive"
    return
  fi
  if powered; then
    bluetoothctl power off >/dev/null 2>&1
    hyprctl notify 5 2000 "rgb(7aa2f7)" "Bluetooth off"
  else
    bluetoothctl power on >/dev/null 2>&1
    hyprctl notify 5 2000 "rgb(7aa2f7)" "Bluetooth on"
  fi
}

case "$1" in
  --icon)   icon ;;
  --name)   name ;;
  --state)  state ;;
  --toggle) toggle ;;
  *) echo "usage: $0 [--icon|--name|--state|--toggle]" ;;
esac

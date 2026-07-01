#!/usr/bin/env bash
# Night light via wlsunset (constant 3500K when on). Wayland-native, no geo.

TEMP=3500

running() { pgrep -x wlsunset >/dev/null 2>&1; }

# "true"/"false" for the eww active class.
state() { if running; then echo true; else echo false; fi; }

on() {
  running || wlsunset -t "$TEMP" -T "$TEMP" >/dev/null 2>&1 &
  hyprctl notify 5 2000 "rgb(e0af68)" "Night light on"
}

off() {
  pkill -x wlsunset >/dev/null 2>&1
  hyprctl notify 5 2000 "rgb(7aa2f7)" "Night light off"
}

toggle() { if running; then off; else on; fi; }

case "$1" in
  --state)  state ;;
  --toggle) toggle ;;
  *) echo "usage: $0 [--state|--toggle]" ;;
esac

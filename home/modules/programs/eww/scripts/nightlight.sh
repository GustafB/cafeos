#!/usr/bin/env bash
# Night light pill: pauses/resumes the wlsunset user service (which follows
# sunset/sunrise from home/modules/hyprland/services/wlsunset.nix). Never
# spawn wlsunset directly -- a second instance fights the service for gamma.

unit="wlsunset.service"

running() { systemctl --user is-active -q "$unit"; }

# "true"/"false" for the eww active class.
state() { if running; then echo true; else echo false; fi; }

on() {
  systemctl --user start "$unit"
  hyprctl notify 5 2000 "rgb(e0af68)" "Night light on (follows sunset)"
}

off() {
  systemctl --user stop "$unit"
  hyprctl notify 5 2000 "rgb(7aa2f7)" "Night light off"
}

toggle() { if running; then off; else on; fi; }

case "$1" in
  --state)  state ;;
  --toggle) toggle ;;
  *) echo "usage: $0 [--state|--toggle]" ;;
esac

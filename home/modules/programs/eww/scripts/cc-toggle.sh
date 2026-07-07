#!/usr/bin/env bash
# Open/close the control center. eww pauses defpolls that no open window
# uses, so on the first open after a reload the notification vars still hold
# their initial values until the next poll tick; prime them here so the
# panel is populated the moment it appears.

dir="$(cd "$(dirname "$0")" && pwd)"

eww update cc-power=false 2>/dev/null
eww open --toggle controlcenter 2>/dev/null

if eww active-windows 2>/dev/null | grep -q controlcenter; then
  eww update \
    cc-notifs="$(bash "$dir/notifications.sh" --list)" \
    cc-dnd="$(bash "$dir/notifications.sh" --dnd-state)" \
    2>/dev/null &
fi

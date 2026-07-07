#!/usr/bin/env bash
# power-profiles-daemon backend for the control center chip.
# --get prints the active profile ("none" when ppd is unavailable, so the
# chip can hide itself); --cycle steps saver -> balanced -> performance.

cur() { powerprofilesctl get 2>/dev/null; }

case "$1" in
  --get)
    p=$(cur)
    echo "${p:-none}"
    ;;
  --cycle)
    case "$(cur)" in
      power-saver) next=balanced ;;
      balanced)    next=performance ;;
      *)           next=power-saver ;;
    esac
    powerprofilesctl set "$next" 2>/dev/null
    ;;
  *) echo "usage: $0 [--get|--cycle]" ;;
esac

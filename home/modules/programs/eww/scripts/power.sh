#!/usr/bin/env bash
# power-profiles-daemon backend for the control center chip.
# --get prints the active profile ("none" when ppd is unavailable, so the
# chip can hide itself); --cycle steps to the next AVAILABLE profile --
# not every host exposes performance (needs platform driver support).

cur() { powerprofilesctl get 2>/dev/null; }

case "$1" in
  --get)
    p=$(cur)
    echo "${p:-none}"
    ;;
  --cycle)
    mapfile -t profiles < <(powerprofilesctl list 2>/dev/null \
      | sed -n 's/^[* ]*\([a-z-]*\):$/\1/p')
    [ "${#profiles[@]}" -gt 0 ] || exit 0
    c=$(cur)
    next="${profiles[0]}"
    for i in "${!profiles[@]}"; do
      if [ "${profiles[$i]}" = "$c" ]; then
        next="${profiles[$(( (i + 1) % ${#profiles[@]} ))]}"
        break
      fi
    done
    powerprofilesctl set "$next" 2>/dev/null
    ;;
  *) echo "usage: $0 [--get|--cycle]" ;;
esac

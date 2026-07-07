#!/usr/bin/env bash
# Night light pill = "force warm NOW". Off = the scheduled wlsunset service
# (home/modules/hyprland/services/wlsunset.nix) runs normally, warming after
# sunset. On = stop the scheduler and run a constant-warm wlsunset instead.
# State tracks the forced instance's pid, so the pill is only lit while the
# screen is actually forced warm (not merely "scheduler running").

TEMP=4000
unit="wlsunset.service"
statefile="${XDG_RUNTIME_DIR:-/tmp}/cafeos-nightforce"

forced() {
  [ -f "$statefile" ] || return 1
  kill -0 "$(cat "$statefile")" 2>/dev/null && return 0
  rm -f "$statefile" # stale pid (crash/relogin); schedule owns gamma again
  return 1
}

state() { if forced; then echo true; else echo false; fi; }

on() {
  systemctl --user stop "$unit"
  # -T must be strictly higher than -t; 1K apart = constant temp in practice
  wlsunset -t "$TEMP" -T "$((TEMP + 1))" >/dev/null 2>&1 &
  echo $! > "$statefile"
  hyprctl notify 5 2000 "rgb(e0af68)" "Night light forced on"
}

off() {
  kill "$(cat "$statefile")" 2>/dev/null
  rm -f "$statefile"
  systemctl --user start "$unit"
  hyprctl notify 5 2000 "rgb(7aa2f7)" "Night light back on schedule"
}

toggle() { if forced; then off; else on; fi; }

case "$1" in
  --state)  state ;;
  --toggle) toggle ;;
  *) echo "usage: $0 [--state|--toggle]" ;;
esac

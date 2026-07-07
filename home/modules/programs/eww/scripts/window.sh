#!/usr/bin/env bash
# Emit the active window title, refreshed on Hyprland focus/title events.
set -uo pipefail

socket="${XDG_RUNTIME_DIR}/hypr/${HYPRLAND_INSTANCE_SIGNATURE}/.socket2.sock"

# jq -j: no trailing newline; the echo is each emission's only newline
emit() { hyprctl activewindow -j | jq -j '.title // ""' | head -c 90; echo; }

emit
socat -U - "UNIX-CONNECT:${socket}" 2>/dev/null | while read -r line; do
  case "$line" in
    activewindow*|closewindow*|openwindow*|windowtitle*|focusedmon*) emit ;;
  esac
done

#!/usr/bin/env bash
# Emit a JSON array of workspaces 1..10 with {id, active, occupied},
# refreshed on every Hyprland workspace event (via the socket2 event stream).
set -euo pipefail

socket="${XDG_RUNTIME_DIR}/hypr/${HYPRLAND_INSTANCE_SIGNATURE}/.socket2.sock"

emit() {
  local active occupied
  active=$(hyprctl activeworkspace -j | jq '.id')
  occupied=$(hyprctl workspaces -j | jq -c '[.[].id]')
  jq -cn --argjson act "${active:-1}" --argjson occ "${occupied:-[]}" \
    '[range(1;11) | {id: ., active: (. == $act), occupied: ($occ | index(.) != null)}]'
}

emit
socat -U - "UNIX-CONNECT:${socket}" 2>/dev/null | while read -r line; do
  case "$line" in
    workspace*|createworkspace*|destroyworkspace*|focusedmon*|moveworkspace*) emit ;;
  esac
done

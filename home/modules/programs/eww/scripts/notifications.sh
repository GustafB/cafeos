#!/usr/bin/env bash
# mako notification history + do-not-disturb backend for the control center.
# Degrades to empty output when mako is not running.

case "$1" in
  --list)
    # Compact [{app, summary, body}] of the most recent history entries.
    out=$(makoctl history -j 2>/dev/null | jq -c '
      [ .[]
        | { app:     (.app_name // "notify"),
            summary: (.summary // ""),
            body:    ((.body // "") | gsub("\\s+"; " ") | .[:100]) } ]
      | .[:5]' 2>/dev/null)
    echo "${out:-[]}"
    ;;

  --dnd-state)
    makoctl mode 2>/dev/null | grep -qx "do-not-disturb" && echo true || echo false
    ;;

  --dnd-toggle)
    makoctl mode -t do-not-disturb >/dev/null 2>&1
    ;;

  --clear)
    # mako has no history-clear command; a restart wipes the buffer.
    systemctl --user restart mako 2>/dev/null
    ;;

  *) echo "usage: $0 [--list|--dnd-state|--dnd-toggle|--clear]" ;;
esac

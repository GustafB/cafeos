#!/usr/bin/env bash
# Volume control via wireplumber (wpctl) on the default sink.
sink="@DEFAULT_AUDIO_SINK@"

muted() { wpctl get-volume "$sink" 2>/dev/null | grep -q MUTED; }
level() { wpctl get-volume "$sink" 2>/dev/null | awk '{print int($2*100)}'; }

case "${1:-get}" in
  get) level ;;
  muted) muted && echo true || echo false ;;
  icon)
    if muted; then echo "󰝟"; else
      v=$(level)
      if   [ "${v:-0}" -eq 0 ];   then echo "󰕿"
      elif [ "${v:-0}" -lt 50 ];  then echo "󰖀"
      else echo "󰕾"; fi
    fi ;;
  set) wpctl set-volume "$sink" "${2}%" ;;
  toggle) wpctl set-mute "$sink" toggle ;;
  scroll)
    if [ "${2}" = "up" ]; then wpctl set-volume -l 1.0 "$sink" 5%+
    else wpctl set-volume "$sink" 5%-; fi ;;
esac

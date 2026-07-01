#!/usr/bin/env bash
# Emit {capacity, status, icon} for the first battery, or status "None" when
# there is no battery (desktop) so the widget can hide itself.
bat=$(ls /sys/class/power_supply/ 2>/dev/null | grep -m1 '^BAT' || true)
if [ -z "$bat" ]; then
  echo '{"capacity":0,"status":"None","icon":"󰂑"}'
  exit 0
fi

cap=$(cat "/sys/class/power_supply/$bat/capacity")
status=$(cat "/sys/class/power_supply/$bat/status")

if [ "$status" = "Charging" ]; then icon="󰂄"
elif [ "$cap" -ge 90 ]; then icon="󰁹"
elif [ "$cap" -ge 60 ]; then icon="󰂀"
elif [ "$cap" -ge 30 ]; then icon="󰁾"
elif [ "$cap" -ge 10 ]; then icon="󰁻"
else icon="󰁺"; fi

jq -cn --argjson c "$cap" --arg s "$status" --arg i "$icon" \
  '{capacity:$c, status:$s, icon:$i}'

#!/usr/bin/env bash
# Current weather for the bar island via Open-Meteo (no API key).
# Prints {"temp":"18°","icon":"...","desc":"Clear"}; empty temp = hide island.
# Keep coordinates in sync with home/modules/hyprland/services/wlsunset.nix.

LAT=59.3
LON=18.1

fail() { echo '{"temp":"","icon":"","desc":""}'; exit 0; }

cur=$(curl -sf --max-time 5 \
  "https://api.open-meteo.com/v1/forecast?latitude=$LAT&longitude=$LON&current=temperature_2m,weather_code,is_day" \
  | jq -c '.current') || fail
[ -n "$cur" ] || fail

echo "$cur" | jq -c '
  (.weather_code) as $c | (.is_day == 1) as $day |
  { temp: ((.temperature_2m | round | tostring) + "°"),
    icon: (if   $c == 0            then (if $day then "󰖙" else "󰖔" end)
           elif $c <= 2            then (if $day then "󰖕" else "󰼱" end)
           elif $c == 3            then "󰖐"
           elif $c <= 48           then "󰖑"
           elif $c <= 57           then "󰖗"
           elif $c <= 67           then "󰖖"
           elif $c <= 77           then "󰖘"
           elif $c <= 82           then "󰖖"
           elif $c <= 86           then "󰖘"
           else                         "󰖓" end),
    desc: (if   $c == 0  then "Clear"
           elif $c <= 2  then "Partly cloudy"
           elif $c == 3  then "Overcast"
           elif $c <= 48 then "Fog"
           elif $c <= 57 then "Drizzle"
           elif $c <= 67 then "Rain"
           elif $c <= 77 then "Snow"
           elif $c <= 82 then "Showers"
           elif $c <= 86 then "Snow showers"
           else               "Thunderstorm" end) }'

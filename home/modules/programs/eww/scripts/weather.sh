#!/usr/bin/env bash
# Current weather for the bar island via Open-Meteo (no API key).
# Prints {"temp":"18°","icon":"...","desc":"Clear"}; empty temp = hide island.
# Coordinates come from ~/.config/cafeos/location.conf, generated from
# hosts/*/variables.nix (same source as the wlsunset night-light schedule).

LAT=59.3 LON=18.1 # fallback if the conf is missing
[ -f "$HOME/.config/cafeos/location.conf" ] && . "$HOME/.config/cafeos/location.conf"

fail() { echo '{"temp":"","icon":"","desc":""}'; exit 0; }

curl -sf --max-time 5 \
  "https://api.open-meteo.com/v1/forecast?latitude=$LAT&longitude=$LON&current=temperature_2m,weather_code,is_day" \
  | jq -ce '
      .current | .weather_code as $c | (.is_day == 1) as $day |
      # one row per WMO code range: [icon, desc]
      (if   $c == 0  then [(if $day then "󰖙" else "󰖔" end), "Clear"]
       elif $c <= 2  then [(if $day then "󰖕" else "󰼱" end), "Partly cloudy"]
       elif $c == 3  then ["󰖐", "Overcast"]
       elif $c <= 48 then ["󰖑", "Fog"]
       elif $c <= 57 then ["󰖗", "Drizzle"]
       elif $c <= 67 then ["󰖖", "Rain"]
       elif $c <= 77 then ["󰖘", "Snow"]
       elif $c <= 82 then ["󰖖", "Showers"]
       elif $c <= 86 then ["󰖘", "Snow showers"]
       else               ["󰖓", "Thunderstorm"] end) as [$icon, $desc] |
      # round + 0 normalizes IEEE negative zero (-0.3 would render "-0°")
      { temp: ((.temperature_2m | round + 0 | tostring) + "°"),
        icon: $icon, desc: $desc }' || fail

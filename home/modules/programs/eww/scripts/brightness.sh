#!/usr/bin/env bash
# Backlight control via brightnessctl. Prints -1 when there is no backlight
# device (e.g. the desktop host), so the widget can hide itself.
case "${1:-get}" in
  get)
    max=$(brightnessctl m 2>/dev/null)
    if [ -z "$max" ] || [ "$max" -eq 0 ] 2>/dev/null; then echo "-1"; else
      echo $(( 100 * $(brightnessctl g) / max ))
    fi ;;
  set) brightnessctl -q s "${2}%" ;;
  # relative step for the hardware keys, e.g. `step +5` / `step -5`
  step)
    case "$2" in
      +*) brightnessctl -q s "${2#+}%+" ;;
      -*) brightnessctl -q s "${2#-}%-" ;;
    esac ;;
esac

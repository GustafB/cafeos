#!/usr/bin/env bash
# playerctl wrapper for the eww music player. WM-agnostic.
# Adapted from gh0stzk/dotfiles (MPRIS-only, no MPD branch).

cache_dir="${XDG_CACHE_HOME:-$HOME/.cache}/cafeos"
cover="$cache_dir/cover.png"
mkdir -p "$cache_dir"

# Active player: the first one that is actually Playing, else the first listed.
player() {
  playerctl -l >/dev/null 2>&1 || { echo ""; return; }
  local p
  p=$(playerctl -l 2>/dev/null | while read -r name; do
        [ "$(playerctl -p "$name" status 2>/dev/null)" = "Playing" ] && { echo "$name"; break; }
      done)
  [ -z "$p" ] && p=$(playerctl -l 2>/dev/null | head -n1)
  echo "$p"
}

P=$(player)
meta() { [ -n "$P" ] && playerctl -p "$P" metadata --format "$1" 2>/dev/null; }

case "$1" in
  --player)   echo "${P:-None}" ;;
  --status)   [ -n "$P" ] && playerctl -p "$P" status 2>/dev/null || echo "Stopped" ;;
  --title)    meta '{{title}}' ;;
  --artist)   meta '{{artist}}' ;;
  --position) meta '{{position}}' ;;                    # microseconds
  --length)   meta '{{mpris:length}}' ;;                # microseconds
  --posseconds) echo $(( $(meta '{{position}}' || echo 0) / 1000000 )) ;;
  --lenseconds) echo $(( $(meta '{{mpris:length}}' || echo 0) / 1000000 )) ;;
  --time)     meta '{{duration(position)}} / {{duration(mpris:length)}}' ;;
  --shuffle)  [ -n "$P" ] && playerctl -p "$P" shuffle 2>/dev/null || echo "Off" ;;
  --loop)     [ -n "$P" ] && playerctl -p "$P" loop 2>/dev/null || echo "None" ;;
  --cover)
    url=$(meta '{{mpris:artUrl}}')
    case "$url" in
      file://*) echo "${url#file://}" ;;
      http*)    curl -sfL "$url" -o "$cover" 2>/dev/null && echo "$cover" || echo "" ;;
      *)        echo "" ;;
    esac
    ;;
  --playpause) [ -n "$P" ] && playerctl -p "$P" play-pause ;;
  --next)      [ -n "$P" ] && playerctl -p "$P" next ;;
  --prev)      [ -n "$P" ] && playerctl -p "$P" previous ;;
  --toggle-shuffle) [ -n "$P" ] && playerctl -p "$P" shuffle toggle ;;
  --toggle-loop)
    case "$(meta '{{loop}}')" in
      None)  playerctl -p "$P" loop Playlist ;;
      Playlist) playerctl -p "$P" loop Track ;;
      *)     playerctl -p "$P" loop None ;;
    esac
    ;;
  --seek) [ -n "$P" ] && playerctl -p "$P" position "$2" ;;   # seconds, absolute
  *) echo "usage: $0 [--player|--status|--title|--artist|--cover|--time|--posseconds|--lenseconds|--shuffle|--loop|--playpause|--next|--prev|--toggle-shuffle|--toggle-loop|--seek N]" ;;
esac

# no-player is a normal state; a non-zero exit makes eww warn on every poll
exit 0

{
  pkgs,
  username,
  ...
}:
let
  rasiDir = "/home/${username}/.config/rofi/themes";
  wallpaperDir = "/home/${username}/.config/cafeos-assets/wallpapers";
  repoVars = "/home/${username}/cafeos/hosts/$(hostname)/variables.nix";

  # Glass rofi password prompt for sudo -A (retries come back as new prompts).
  rofi-askpass = pkgs.writeShellScriptBin "rofi-askpass" ''
    rofi -dmenu -password -p "sudo" -theme ${rasiDir}/askpass.rasi </dev/null
  '';

  # theme-set <image>: point vars.wallpaper at it and rebuild. Stylix derives
  # the palette from the wallpaper at build time and fans it out everywhere,
  # so the rebuild IS the theme switch.
  theme-set = pkgs.writeShellScriptBin "theme-set" ''
    set -euo pipefail
    wp="$1"
    [ -f "$wp" ] || { echo "no such wallpaper: $wp" >&2; exit 1; }

    name=$(basename "$wp")
    if [ ! -w ${repoVars} ]; then
      notify-send "Theme" "cannot write ${repoVars}" || true
      exit 1
    fi
    ${pkgs.gnused}/bin/sed -i "s/wallpaper = \"[^\"]*\"/wallpaper = \"$name\"/" ${repoVars}

    # Password FIRST (rofi askpass caches the sudo credential), THEN the
    # fullscreen progress overlay -- otherwise the overlay would sit on top
    # of the password prompt. The sudo -v validation MUST happen inside the
    # setsid session: credential caches are per-session, so validating before
    # detaching leaves sudo -n with nothing.
    export SUDO_ASKPASS=${rofi-askpass}/bin/rofi-askpass
    ${pkgs.util-linux}/bin/setsid -f bash -c '
      log=$1; name=$2; flake=$3
      if ! sudo -A -v 2>/dev/null; then
        notify-send "Theme" "Cancelled" || true
        exit 0
      fi
      : > "$log"
      eww update rebuild-status="evaluating" rebuild-pct=3 2>/dev/null || true
      eww open rebuildsplash 2>/dev/null || notify-send "Theme" "Rebuilding with $name..."

      # sudo -n: uses the credential just cached by sudo -v, never prompts
      sudo -n nixos-rebuild switch --flake "$flake" > "$log" 2>&1 &
      rpid=$!

      while kill -0 "$rpid" 2>/dev/null; do
        total=$(grep -m1 -oE "these [0-9]+ derivations" "$log" | grep -oE "[0-9]+" || true)
        cnt=$(grep -c "^building ./nix/store" "$log" || true)
        if [ -n "$total" ] && [ "$total" -gt 0 ]; then
          pct=$(( cnt * 100 / total )); [ "$pct" -gt 100 ] && pct=100
          eww update rebuild-status="$cnt/$total derivations" rebuild-pct="$pct" 2>/dev/null || true
        fi
        sleep 2
      done

      if wait "$rpid"; then
        eww update rebuild-status="restyling" rebuild-pct=100 2>/dev/null || true
        # reload restyles the daemon in place (no bar blink); fall back to a
        # hard restart if the flaky reload fails
        if ! eww reload 2>/dev/null; then
          eww kill 2>/dev/null; sleep 1
          eww daemon 2>/dev/null; sleep 2
          eww open bar 2>/dev/null
        fi
        sleep 1
        eww close rebuildsplash 2>/dev/null || true
        notify-send "Theme" "Applied $name"
      else
        eww close rebuildsplash 2>/dev/null || true
        notify-send -u critical "Theme" "Rebuild failed - see $log"
      fi
    ' theme-rebuild /tmp/theme-rebuild.log "$name" "/home/${username}/cafeos#$(hostname)" >/dev/null 2>&1 || true
  '';

  # wallpaper-menu: rofi grid of wallpaper previews -> theme-set
  wallpaper-menu = pkgs.writeShellScriptBin "wallpaper-menu" ''
    set -euo pipefail
    dir="${wallpaperDir}"
    thumbs="$HOME/.cache/wallpaper-thumbs"
    mkdir -p "$thumbs"

    # entries carry a NUL (rofi icon metadata), so printf straight into the
    # pipe -- a NUL can't live in a shell variable.
    chosen=$(
      for f in "$dir"/*.jpg "$dir"/*.jpeg "$dir"/*.png; do
        [ -e "$f" ] || continue
        name=$(basename "$f"); name="''${name%.*}"
        thumb="$thumbs/$name.png"
        if [ ! -e "$thumb" ] || [ "$(readlink -f "$f")" -nt "$thumb" ]; then
          ${pkgs.imagemagick}/bin/magick "$(readlink -f "$f")" \
            -resize 400x225^ -gravity center -extent 400x225 "$thumb"
        fi
        printf '%s\0icon\x1f%s\n' "$name" "$thumb"
      done | rofi -dmenu -p "󰸉 Wallpaper" -show-icons \
                  -theme ${rasiDir}/wallpaper.rasi
    ) || exit 0
    [ -n "$chosen" ] || exit 0
    for f in "$dir/$chosen".jpg "$dir/$chosen".jpeg "$dir/$chosen".png; do
      [ -e "$f" ] && exec theme-set "$f"
    done
  '';
in
{
  home.packages = [
    theme-set
    wallpaper-menu
    rofi-askpass
  ];

  # picker + askpass themes (import shared.rasi from the same dir)
  xdg.configFile."rofi/themes/wallpaper.rasi".source = ./wallpaper.rasi;
  xdg.configFile."rofi/themes/askpass.rasi".source = ./askpass.rasi;
}

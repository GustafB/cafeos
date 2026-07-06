{
  pkgs,
  username,
  ...
}:
let
  rasiDir = "/home/${username}/.config/rofi/themes";
  wallpaperDir = "/home/${username}/.config/cafeos-assets/wallpapers";
  repoVars = "/home/${username}/cafeos/hosts/$(hostname)/variables.nix";

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

    # Visible rebuild; sudo prompts for the password in this window.
    ${pkgs.util-linux}/bin/setsid -f kitty --title "cafeos theme rebuild" bash -c '
      echo "Rebuilding with wallpaper: '"$name"'"
      sudo nixos-rebuild switch --flake "/home/${username}/cafeos#$(hostname)" \
        && echo -e "\n\033[1;32mtheme applied.\033[0m" \
        || echo -e "\n\033[1;31mrebuild failed.\033[0m"
      read -n1 -rp "press any key to close"
    ' >/dev/null 2>&1 || true
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
  ];

  # picker theme (imports shared.rasi from the same dir)
  xdg.configFile."rofi/themes/wallpaper.rasi".source = ./wallpaper.rasi;
}

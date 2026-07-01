{
  pkgs,
  lib,
  vars,
  ...
}:
# Central theming engine. A single base16 palette is the source of truth and
# Stylix fans it out to every app it knows about (kitty, waybar, rofi, hyprland
# borders, gtk, qt, btop, bat, fzf, the tty, ...). Gated on `vars.gui` so the
# headless WSL host is untouched.
#
# Phase two (dynamic theming) swaps `base16Scheme` for a wallpaper-derived
# palette (or matugen) without touching any of the per-app wiring.
lib.mkIf vars.gui {
  stylix = {
    enable = true;
    polarity = "dark";

    # Tokyo Night — "Night" variant (background #1a1b26).
    base16Scheme = "${pkgs.base16-schemes}/share/themes/tokyo-night-dark.yaml";

    # Stylix expects a wallpaper image; reuse the repo asset. hyprpaper.nix
    # remains the authority on actually painting the wallpaper (see the target
    # disabled in that module) — this just satisfies Stylix's requirement.
    image = ../../home/modules/hyprland/config/assets/wallpapers/wallpaper.jpg;

    fonts = {
      monospace = {
        package = pkgs.nerd-fonts.jetbrains-mono;
        name = "JetBrainsMono Nerd Font Mono";
      };
      sansSerif = {
        package = pkgs.montserrat;
        name = "Montserrat";
      };
      serif = {
        package = pkgs.montserrat;
        name = "Montserrat";
      };
    };
  };
}

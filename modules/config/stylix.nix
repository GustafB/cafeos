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
# Dynamic theming: no base16Scheme is set, so Stylix derives a dark palette
# from `vars.wallpaper` — swap the wallpaper in variables.nix, rebuild, and
# every app follows.
lib.mkIf vars.gui {
  stylix = {
    enable = true;
    polarity = "dark";

    # Slight terminal translucency; hyprland blurs behind it (glass look).
    opacity.terminal = 0.92;

    # Palette seed AND the image hyprpaper paints (hyprpaper.nix reads the
    # same vars.wallpaper; its Stylix target stays disabled for multi-monitor
    # control).
    image = ../../home/modules/hyprland/config/assets/wallpapers/${vars.wallpaper};

    cursor = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Classic";
      size = 24;
    };

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

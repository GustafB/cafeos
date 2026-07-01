{
  username,
  lib,
  ...
}:
let
  wallpaperDir = "/home/${username}/.config/cafeos-assets/wallpapers";
in
{
  # This module is the sole authority on the wallpaper (multi-monitor aware).
  # Stylix's hyprpaper target would also write services.hyprpaper.settings and
  # conflict; the hyprland target force-enables it, so mkForce to override.
  stylix.targets.hyprpaper.enable = lib.mkForce false;

  services.hyprpaper = {
    enable = true;
    settings = {
      ipc = "off";
      splash = "false";
      preload = [
        "${wallpaperDir}/wallpaper.jpg"
      ];
      # empty monitor = apply to every output (host-agnostic: desktop DP-*,
      # laptop eDP-1, etc.)
      wallpaper = [
        ",${wallpaperDir}/wallpaper.jpg"
      ];
    };
  };
}

{
  username,
  vars,
  lib,
  ...
}:
let
  wallpaper = "/home/${username}/.config/cafeos-assets/wallpapers/${vars.wallpaper}";
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
      # hyprpaper 0.8+ block syntax; the old `wallpaper = ,path` one-liner
      # parses but silently paints nothing. Empty monitor = every output
      # (host-agnostic: desktop DP-*, laptop eDP-1, etc.); no preload needed.
      wallpaper = {
        monitor = "";
        path = wallpaper;
      };
    };
  };
}

{
  username,
  ...
}:
let
  wallpaperDir = "/home/${username}/.config/cafeos-assets/wallpapers";
in
{
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

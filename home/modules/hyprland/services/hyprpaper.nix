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
      wallpaper = [
        "DP-3,${wallpaperDir}/wallpaper.jpg"
        "DP-4,${wallpaperDir}/wallpaper.jpg"
      ];
    };
  };
}

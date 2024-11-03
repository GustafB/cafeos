{
  assets,
  pkgs,
  lib,
  config,
  inputs,
  ...
}:
{
  services.hyprpaper = {
    enable = true;
    settings = {
      ipc = "off";
      splash = "false";
      preload = [
        "/home/cafebabe/cafeos/config/wallpapers/wallpaper.jpg"
      ];
      wallpaper = [
        "DP-3,/home/cafebabe/cafeos/config/wallpapers/wallpaper.jpg"
        "DP-4,/home/cafebabe/cafeos/config/wallpapers/wallpaper.jpg"
      ];
    };
  };
}

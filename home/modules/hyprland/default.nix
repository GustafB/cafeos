{
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    ./config/default.nix
    ./programs/hyprlock.nix
    ./services/hypridle.nix
    ./services/hyprpaper.nix
  ];

  home.packages = with pkgs; [
    libnotify
    slurp
    grim
    wl-clipboard
    wl-screenrec
    wlr-randr
  ];
}

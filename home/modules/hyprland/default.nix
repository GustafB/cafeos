{
  pkgs,
  ...
}:
{
  imports = [
    ./config
    ./programs
    ./services
  ];

  home.packages = with pkgs; [
    libnotify
    slurp
    grim
    wl-clipboard
    wl-screenrec
    wlr-randr
    hyprpicker
  ];
}

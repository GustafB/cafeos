{
  pkgs,
  ...
}:
{
  imports = [
    ./config
    ./programs
    ./services

    ./scripts/screenlock.nix
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

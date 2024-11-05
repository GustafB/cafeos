{
  pkgs,
  username,
  host,
  lib,
  ...
}:
{
  home.username = username;
  home.homeDirectory = "/home/${username}";
  home.stateVersion = "24.05";
  fonts.fontconfig.enable = true;

  imports = [
    ../../home/modules/hyprland
    ../../home/modules/dev
    (import ../../home/modules/programs {
      inherit
        lib
        pkgs
        host
        ;
    })
  ];

  home.packages = with pkgs; [
    (import ../../scripts/rofi-launcher.nix { inherit pkgs; })
    (import ../../scripts/screenlock.nix { inherit pkgs; })
    (nerdfonts.override {
      fonts = [
        "JetBrainsMono"
        "DroidSansMono"
      ];
    })
  ];

  programs = {
    home-manager.enable = true;
  };
}

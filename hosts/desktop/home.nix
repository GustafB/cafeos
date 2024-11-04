{
  pkgs,
  config,
  username,
  host,
  lib,
  ...
}:
let
  inherit (import ./variables.nix) gitUsername gitEmail gitPublicKey;
in
{
  home.username = username;
  home.homeDirectory = "/home/${username}";
  home.stateVersion = "24.05";
  fonts.fontconfig.enable = true;

  imports = [
    ../../home/modules/hyprland
    ../../home/modules/dev
    ../../home/modules/programs
    ../../config/neovim.nix
    ../../config/rofi.nix
    ../../config/waybar.nix
  ];

  home.packages = with pkgs; [
    (import ../../scripts/rofi-launcher.nix { inherit pkgs; })
    (import ../../scripts/screenlock.nix { inherit pkgs; })
    (pkgs.nerdfonts.override {
      fonts = [
        "JetBrainsMono"
        "DroidSansMono"
      ];
    })
  ];

  programs.git = import ../../config/git.nix {
    inherit
      pkgs
      lib
      gitUsername
      gitEmail
      gitPublicKey
      ;
  };

  programs = {
    home-manager.enable = true;
  };
}

{
  pkgs,
  username,
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
    ../../home/modules/shell
    ../../home/modules/programs
    ../../home/modules/config
  ];

  programs = {
    home-manager.enable = true;
  };
}

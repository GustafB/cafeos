{
  lib,
  username,
  vars,
  ...
}:
{
  home.username = username;
  home.homeDirectory = "/home/${username}";
  home.stateVersion = "26.05";
  fonts.fontconfig.enable = vars.gui;

  imports = [
    ../../home/modules/dev
    ../../home/modules/shell
    ../../home/modules/programs
    ../../home/modules/config
  ]
  ++ lib.optionals vars.gui [
    ../../home/modules/desktop
  ];
}

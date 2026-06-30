{
  lib,
  username,
  vars,
  ...
}:
{
  home.username = username;
  home.homeDirectory = "/home/${username}";
  # NB: home-manager has its own stateVersion enum (released HM versions),
  # distinct from NixOS's system.stateVersion. Newest the pinned HM supports.
  home.stateVersion = "24.11";
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

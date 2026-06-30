{
  pkgs,
  lib,
  vars,
  ...
}:
lib.mkIf vars.gui {
  programs.thunar = {
    enable = true;

    plugins = with pkgs.xfce; [
      thunar-archive-plugin
      thunar-media-tags-plugin
      thunar-volman
    ];
  };
}

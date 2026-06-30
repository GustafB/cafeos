{
  inputs,
  pkgs,
  lib,
  vars,
  ...
}:
lib.mkIf vars.gui {
  programs.hyprland = {
    enable = true;
    package = inputs.hyprland.packages."${pkgs.system}".default;
    portalPackage = inputs.hyprland.packages.${pkgs.system}.xdg-desktop-portal-hyprland;
  };

}

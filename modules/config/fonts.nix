{
  pkgs,
  lib,
  vars,
  ...
}:
lib.mkIf vars.gui {
  fonts = {
    enableDefaultPackages = false;

    packages = with pkgs; [
      corefonts

      # nerdfonts.override was removed; fonts are now individual packages
      # under the nerd-fonts namespace.
      nerd-fonts.jetbrains-mono
      nerd-fonts.droid-sans-mono

    ];
  };

}

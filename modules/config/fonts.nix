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

      (nerdfonts.override {
        fonts = [
          "JetBrainsMono"
          "DroidSansMono"
        ];
      })

    ];
  };

}

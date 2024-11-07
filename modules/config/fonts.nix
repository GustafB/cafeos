{ pkgs, ... }:
{
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

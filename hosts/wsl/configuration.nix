{
  pkgs,
  host,
  username,
  ...
}:

{
  imports = [
    <nixos-wsl/modules>
    ./hardware.nix
    ./users.nix

    ../../modules/config/il8.nix
    ../../modules/config/xdg.nix
    ../../modules/config/security.nix
    ../../modules/config/fonts.nix
    ../../modules/config/garbage-collection.nix
    ../../modules/config/virtualization.nix

    ../../modules/hardware/graphics.nix
    ../../modules/hardware/nvidia.nix
    ../../modules/hardware/bluetooth.nix

    ../../modules/programs

    ../../modules/services
  ];

  time.timeZone = "Europe/Stockholm";

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    vim
    git
    fastfetch
    brave
    lshw
    pkg-config
    lxqt.lxqt-policykit
  ];

  services = {
    libinput.enable = true;
  };

  system.stateVersion = "24.05";
}

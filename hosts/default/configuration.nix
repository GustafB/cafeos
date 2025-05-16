{
  pkgs,
  host,
  username,
  ...
}:

{
  imports = [
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

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = host;

  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Stockholm";

  # enable nvidia drivers
  drivers.nvidia.enable = true;

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    vim
    kitty
    git
    fastfetch
    brave
    lshw
    pkg-config
    libnotify
    lxqt.lxqt-policykit
  ];

  services = {
    libinput.enable = true;
  };

  system.stateVersion = "24.11";
}

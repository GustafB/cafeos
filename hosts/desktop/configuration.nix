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

    ../../modules
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

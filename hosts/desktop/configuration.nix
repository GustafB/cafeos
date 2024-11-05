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

    ../../modules/hardware/graphics.nix
    ../../modules/hardware/nvidia.nix
    ../../modules/hardware/bluetooth.nix

    ../../modules/programs

    (import ../../modules/services { inherit pkgs username; })
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
    wget
    curl
    killall
    jq
    kitty
    git
    btop
    killall
    fastfetch
    eza
    fzf
    tree
    fd
    bat
    brave
    libvirt
    ripgrep
    lshw
    pkg-config
    libnotify
    unrar
    unzip
    lxqt.lxqt-policykit
  ];

  # fonts = {
  #   packages = with pkgs; [
  #     (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
  #   ];
  #   fontconfig = {
  #     defaultFonts = {
  #       monospace = [ "JetBrainsMono Nerd Font Mono" ];
  #       serif = [ "Montserrat" ];
  #       sansSerif = [ "Montserrat" ];
  #     };
  #   };
  # };

  services = {
    # xserver = {
    #   enable = false;
    #   xkb = {
    #     layout = "us";
    #     variant = "";
    #   };
    # };
    libinput.enable = true;
  };

  system.stateVersion = "24.05";
}

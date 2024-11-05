{
  config,
  pkgs,
  host,
  username,
  options,
  lib,
  inputs,
  modulesPath,
  ...
}:

{
  imports = [
    ./hardware.nix
    ./users.nix

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

  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "sv_SE.UTF-8";
    LC_IDENTIFICATION = "sv_SE.UTF-8";
    LC_MEASUREMENT = "sv_SE.UTF-8";
    LC_MONETARY = "sv_SE.UTF-8";
    LC_NAME = "sv_SE.UTF-8";
    LC_NUMERIC = "sv_SE.UTF-8";
    LC_PAPER = "sv_SE.UTF-8";
    LC_TELEPHONE = "sv_SE.UTF-8";
    LC_TIME = "sv_SE.UTF-8";
  };

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
    killall
    curl
    jq
    kitty
    git
    htop
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
    greetd.tuigreet
    libsecret
    git-crypt
    lxqt.lxqt-policykit
    lazygit
    clang_14
    grim
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

  # grapics
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
      pkgs.xdg-desktop-portal
    ];
    configPackages = [
      pkgs.xdg-desktop-portal-gtk
      pkgs.xdg-desktop-portal-hyprland
      pkgs.xdg-desktop-portal
    ];
  };

  hardware.graphics = {
    enable = true;
    enable32Bit = false;
  };

  services = {
    xserver = {
      enable = false;
      xkb = {
        layout = "us";
        variant = "";
      };
    };
    libinput.enable = true;
  };

  security = {
    pam.services.hyprlock = { };
    rtkit.enable = true;
    polkit = {
      enable = true;
      extraConfig = ''
        polkit.addRule(function(action, subject) {
              if (
                  subject.isInGroup("users")
                  && (
                    action.id == "org.freedesktop.login1.reboot" ||
                    action.id == "org.freedesktop.login1.reboot-multiple-sessions" ||
                    action.id == "org.freedesktop.login1.power-off" ||
                    action.id == "org.freedesktop.login1.power-off-multiple-sessions"
                  )
              )
              {
                return polkit.Result.YES;
              }
          })
      '';
    };
  };

  system.stateVersion = "24.05";
}

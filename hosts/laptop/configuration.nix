{ config, pkgs, host, username, options, lib, inputs, modulesPath, ... }:

{
  imports =
    [ 
      ./hardware-configuration.nix
      ./users.nix
    ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  
  networking.hostName = host; # Define your hostname.

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Stockholm";

  # Select internationalisation properties.
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


  nix.settings.experimental-features = ["nix-command" "flakes"];

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
    eza
    fzf
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
    hyprlock
    swww
    waybar
    rofi
    git-crypt
    starship
    lxqt.lxqt-policykit
    _1password
    _1password-gui
  ];
	
  
  programs = {
    starship = {
      enable = true;
      settings = {
        add_newline = false;
      };
    };
    _1password.enable = true;
    _1password-gui = {
      enable = true;
      polkitPolicyOwners = [ "{$username}" ];
    };
  };

    # grapics
  programs.hyprland = {
    enable = true;
    package = inputs.hyprland.packages."${pkgs.system}".hyprland;
  };


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
      videoDrivers = ["nvidia"];
      xkb = {
        layout = "us";
        variant = "";
      };
    };
    greetd = {
      enable = true;
      vt = 3;
      settings = {
        default_session = {
          user = username;
          command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --time-format '%I:%M %p | %a * %h | %F' --cmd Hyprland";
        };
      };
    };
    openssh = {
       enable = true;
       startWhenNeeded = true;
       settings = {
         AllowAgentForwarding = true;
       };
     };
    libinput.enable = true;
  };

  programs.ssh = {
    startAgent = true;
    extraConfig = ''
    Host *
        IdentityAgent ~/.1password/agent.sock
    '';
  };
  
  security.pam.services.hyprlock = {};
  
  
  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = false;
    powerManagement.finegrained = false;
    open = false;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  
    prime = {
      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:1:0:0";
    };
  };
  
  
    # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?


}

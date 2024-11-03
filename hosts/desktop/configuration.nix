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
    ../../modules/programs/hyprland.nix
    ../../modules/nvidia.nix
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
    swww
    waybar
    rofi
    git-crypt
    starship
    lxqt.lxqt-policykit
    _1password
    _1password-gui
    lazygit
    clang_14
    grim
  ];

  fonts = {
    packages = with pkgs; [
      (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
    ];
    fontconfig = {
      defaultFonts = {
        monospace = [ "JetBrainsMono Nerd Font Mono" ];
        serif = [ "Montserrat" ];
        sansSerif = [ "Montserrat" ];
      };
    };
  };

  programs = {
    _1password.enable = true;
    _1password-gui = {
      enable = true;
      polkitPolicyOwners = [ "{$username}" ];
    };
    starship = {
      enable = true;
      package = pkgs.starship;
      settings = {
        add_newline = false;
        buf = {
          symbol = " ";
        };
        c = {
          symbol = " ";
        };
        directory = {
          read_only = " 󰌾";
        };
        docker_context = {
          symbol = " ";
        };
        fossil_branch = {
          symbol = " ";
        };
        git_branch = {
          symbol = " ";
        };
        golang = {
          symbol = " ";
        };
        hg_branch = {
          symbol = " ";
        };
        hostname = {
          ssh_symbol = " ";
        };
        lua = {
          symbol = " ";
        };
        memory_usage = {
          symbol = "󰍛 ";
        };
        meson = {
          symbol = "󰔷 ";
        };
        nim = {
          symbol = "󰆥 ";
        };
        nix_shell = {
          symbol = " ";
        };
        nodejs = {
          symbol = " ";
        };
        ocaml = {
          symbol = " ";
        };
        package = {
          symbol = "󰏗 ";
        };
        python = {
          symbol = " ";
        };
        rust = {
          symbol = " ";
        };
        swift = {
          symbol = " ";
        };
        zig = {
          symbol = " ";
        };
      };
    };
    thunar = {
      enable = true;
      plugins = with pkgs.xfce; [
        thunar-archive-plugin
        thunar-volman
      ];
    };
  };

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
    greetd = {
      enable = true;
      vt = 3;
      settings = {
        initial_session = {
          user = username;
          command = "Hyprland";
        };
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
    pipewire = {
      enable = true;
      audio.enable = true; # enables pavucontrol
      alsa = {
        enable = true;
        support32Bit = true;
      };
      pulse.enable = true;
    };

  };

  programs.ssh = {
    startAgent = true;
    extraConfig = ''
      Host *
      IdentityAgent ~/.1password/agent.sock
    '';
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

  # enable bluetooth
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  services.blueman.enable = true;

  system.stateVersion = "24.05";
}

{
  pkgs,
  config,
  username,
  host,
  lib,
  ...
}:
let
  inherit (import ./variables.nix) gitUsername gitEmail gitPublicKey;
in
{
  home.username = username;
  home.homeDirectory = "/home/${username}";
  home.stateVersion = "24.05";
  fonts.fontconfig.enable = true;

  imports = [
    ../../config/hyprland.nix
    ../../config/neovim.nix
    ../../config/rofi.nix
    ../../config/waybar.nix
  ];

  home.packages = with pkgs; [
    (import ../../scripts/rofi-launcher.nix { inherit pkgs; })
    (import ../../modules/python311.nix { inherit pkgs lib config; })
    (pkgs.nerdfonts.override {
      fonts = [
        "JetBrainsMono"
        "DroidSansMono"
      ];
    })
  ];

  services = {
    hypridle = {
      settings = {
        general = {
          after_sleep_cmd = "hyprctl dispatch dpms on";
          ignore_dbus_inhibit = false;
          lock_cmd = "hyprlock";
        };
        listener = [
          {
            timeout = 900;
            on-timeout = "hyprlock";
          }
          {
            timeout = 1200;
            on-timeout = "hyprctl dispatch dpms off";
            on-resume = "hyprctl dispatch dpms on";
          }
        ];
      };
    };
  };

  programs.git = import ../../config/git.nix {
    inherit
      pkgs
      lib
      gitUsername
      gitEmail
      gitPublicKey
      ;
  };

  programs = {
    home-manager.enable = true;
    kitty = {
      enable = true;
      package = pkgs.kitty;
      settings = {
        scrollback_lines = 2000;
        wheel_scroll_min_lines = 1;
        window_padding_width = 4;
        confirm_os_window_close = 0;
      };
      extraConfig = ''
        tab_bar_style fade
        tab_fade 1
        active_tab_font_style   bold
        inactive_tab_font_style bold
        map alt+minus change_font_size all -1
        map alt+equal change_font_size all +1
      '';
    };
    zsh = {
      enable = true;
      enableCompletion = true;
      # load personal config and enable emacs keybinds for cmdline
      initExtra = ''
        fastfetch
        if [[ -f $HOME/.zshrc-personal ]]; then
        source $HOME/.zshrc-personal
        fi
        bindkey -e
        	  '';
      shellAliases = {
        sv = "sudo nvim";
        v = "nvim";
        cat = "bat";
        ls = "eza --icons";
        ll = "eza -lh --icons --grid --group-directories-first";
        la = "eza -lah --icons --grid --group-directories-first";
        ".." = "cd ..";
        "..2" = "cd ../..";
        "..3" = "cd ../../..";
        "..4" = "cd ../../../..";
        "wifi" = "nmtui";
        rebuild = "sudo nixos-rebuild switch --flake ~/cafeos/#${host}";
        poweroff = "sudo shutdown -h now";
      };
    };
    fzf = {
      enable = true;
    };
    starship = {
      enable = true;
      package = pkgs.starship;
    };
    hyprlock = {
      enable = true;
      settings = {
        general = {
          disable_loading_bar = true;
          grace = 10;
          hide_cursor = true;
          no_fade_in = false;
        };
        background = [
          {
            path = "/home/${username}/cafeos/config/assets/wallpapers/wallpaper.jpg";
            blur_passes = 3;
            blur_size = 8;
          }
        ];
        image = [
          {
            path = "/home/${username}/cafeos/config/assets/images/face.jpg";
            size = 150;
            border_size = 4;
            border_color = "rgb(0C96F9)";
            rounding = -1;
            position = "0, 200";
            halign = "center";
            valign = "center";
          }
        ];
        input-field = [
          {
            size = "200, 50";
            position = "0, -80";
            monitor = "";
            dots_center = true;
            fade_on_empty = false;
            font_color = "rgb(CFE6F4)";
            inner_color = "rgb(657DC2)";
            outer_color = "rgb(0D0E15)";
            outline_thickness = 5;
            placeholder_text = "password...";
            shadow_passes = 2;
          }
        ];
      };
    };
  };
}

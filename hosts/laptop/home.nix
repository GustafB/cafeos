{ pkgs, config, username, host, lib, ... }:
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
    ];

    home.packages = with pkgs; [
      (import ../../scripts/rofi-launcher.nix { inherit pkgs; })
      (pkgs.nerdfonts.override { fonts = [ "JetBrainsMono" "DroidSansMono" ]; })
        (python311.withPackages (
                ps:
                    with ps; [
                    setuptools
                    jupyter
                    jupyterlab
                    ipython
                    ipykernel
                    # DS
                    matplotlib
                    numpy
                    plotly
                    # scikit-learn-extra
                    scipy
                    seaborn
                    pandas
                    # formatter
                    black
                    ruff
                    # other
                    virtualenv
                    ])
            )
    ];

    programs.git = import ../../config/git.nix { inherit pkgs lib gitUsername gitEmail gitPublicKey; };


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
	    rebuild = "sudo nixos-rebuild switch --flake ~/cafeos/#laptop";
	  };
    };
    fzf = {
        enable = true;
    };
    starship = {
        enable = true;
        package = pkgs.starship;
    };
  };
}

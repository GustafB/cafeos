{ pkgs, username, host, lib, ... }:
let
  inherit (import ./variables.nix) gitUsername gitEmail;
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

    home.packages = [
      (import ../../scripts/rofi-launcher.nix { inherit pkgs; })
      (pkgs.nerdfonts.override { fonts = [ "JetBrainsMono" "DroidSansMono" ]; })
    ];

    programs.git = import ../../config/git.nix { inherit pkgs lib gitUsername gitEmail; };

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
            '';
        };
	starship = {
	  enable = true;
	  package = pkgs.starship;
	};
        zsh = {
            enable = true;
            enableCompletion = true;
        };
    };
}

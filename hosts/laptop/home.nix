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
    ];

    home.packages = [
      (import ../../scripts/rofi-launcher.nix { inherit pkgs; })
      (pkgs.nerdfonts.override { fonts = [ "JetBrainsMono" "DroidSansMono" ]; })
    ];

    programs.git = {
        enable = true;
        userName = "${gitUsername}";
        userEmail = "${gitEmail}";
	extraConfig = {
	  gpg = {
	    format = "ssh";
	  };
          "gpg \"ssh\"" = {
            program = "${lib.getExe' pkgs._1password-gui "op-ssh-sign"}";
          };
          commit = {
            gpgsign = true;
          };
          user = {
            signingKey = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC3xxvzZ8cI5XqBhPKtjIxr1MTbELxngSnDd7+V01v50M6DBRjd5xfVv5m/Ev5dVPhynrq4nnc2BrlXTbn3K03/oQEPvzn5Hzhn3TSHmQfkhsiIIjP7DrhWMPR3Yi/Oo+mRhJfzfNL5W8a3eGJ0ESWPHvNwpNoPRnWK1WhoE10KnX7wxWaJGPi2eZIyoChEnKGGKkR9RYaOvcaKH6Wv4iZ0trOsGHg242fom0ZCl18iB3ILaaVekZ3bsapzgtiZ8cBUru8NMS3w7grz9i86g9VXcDXxjK8QbBvyAdjAtyPoXj4K2dNeoe7ayEfG6k9PWgNYrbge+Dc6V00seLmGRGfNU0Gg2Ik5qKuIdBQXqiXQkVihtflj7hD5Hkkeb2xs/GJNBjQhe7rGnEndrOMc0h0ClEDetoh/p6mTIHwJLOcD8H+e8K52crg7KDNxLNlEf9Dd7Dag81KBu5cdLiy056OA3JvaKq3QsydYzaxOjG0PiKig1CA/w2MXxHVW3VcfY8QK3kLtmxoDNY9jKd2sZB39m4vkorDztai7iKBcCXRMFoPmdxg74OgA+vqMubVFcjUWyucNWCdSHroKVZ+mgQJIrQQu04U0fLXy+b6ExMzW1MFfREUvMf1vzNDavqRryhq17WEXKSpYrfdjah0HNA9zIHzyEpiPaTnOi5eL2AnAaw==";
          };
	  credential.helper = "${
	    pkgs.git.override { withLibsecret = true; }
	  }/bin/git-credential-libsecret";
	};
	
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

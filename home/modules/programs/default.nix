{
  lib,
  pkgs,
  host,
  ...
}:
{
  imports = [
    ./kitty.nix
    ./zsh.nix
    ./starship.nix
    ./fzf.nix
    ./waybar.nix
    ./rofi.nix
    ./neovim.nix
    (import ./git.nix { inherit lib pkgs host; })
  ];
}

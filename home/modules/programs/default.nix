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
    (import ./git.nix { inherit lib pkgs host; })
  ];
}

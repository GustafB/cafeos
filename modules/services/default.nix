{
  pkgs,
  username,
  ...
}:
{
  imports = [
    ./pipewire.nix
    ./openssh.nix
    (import ./greetd.nix { inherit pkgs username; })
  ];
}

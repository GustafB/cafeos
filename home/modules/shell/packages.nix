{ pkgs, ... }:
{
  home.packages = with pkgs; [
    coreutils
    vim
    wget
    ripgrep
    curl
    killall
    jq
    zip
    unzip
    unrar
    tree
    gnumake
    gnused
  ];
}

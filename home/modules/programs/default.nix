{
  ...
}:
{
  # Portable (non-GUI) home-manager programs shared by every host.
  # GUI programs (kitty, waybar, rofi) live in ../desktop.
  imports = [
    ./home-manager.nix

    ./neovim.nix
    ./git.nix

    ./go-modules/swaggo.nix
  ];
}

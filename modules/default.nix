{
  ...
}:
{
  # Shared NixOS module tree imported by every host. GUI/hardware-specific
  # modules gate their own config behind `lib.mkIf vars.gui` (or their own
  # enable option, e.g. drivers.nvidia.enable), so a headless host such as WSL
  # can import the exact same set with those features switched off.
  imports = [
    ./config/il8.nix
    ./config/xdg.nix
    ./config/security.nix
    ./config/fonts.nix
    ./config/garbage-collection.nix
    ./config/virtualization.nix

    ./hardware/graphics.nix
    ./hardware/nvidia.nix
    ./hardware/bluetooth.nix

    ./programs
    ./services
  ];
}

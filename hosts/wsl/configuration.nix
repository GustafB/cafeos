{
  pkgs,
  inputs,
  host,
  username,
  ...
}:

{
  imports = [
    # NixOS-WSL provides the WSL integration (no bootloader, no hardware.nix).
    inputs.nixos-wsl.nixosModules.default
    ./users.nix

    # The shared module tree. Everything desktop-specific is gated behind
    # `vars.gui`, which is false for this host, so only the portable bits
    # (locale, nix settings, zsh, ssh, openssh, gc) actually take effect.
    ../../modules
  ];

  wsl = {
    enable = true;
    defaultUser = username;
  };

  networking.hostName = host;

  time.timeZone = "Europe/Stockholm";

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    vim
    git
    wget
    curl
    fastfetch
    pkg-config
  ];

  system.stateVersion = "24.11";
}

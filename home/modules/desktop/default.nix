{
  ...
}:
{
  # GUI-only home-manager modules. Imported only when `vars.gui` is set
  # (see each host's home.nix), so headless hosts such as WSL never pull in
  # Hyprland, the bar, the launcher or the terminal emulator config.
  imports = [
    ../hyprland

    ../programs/kitty.nix
    ../programs/eww
    ../programs/rofi
  ];
}

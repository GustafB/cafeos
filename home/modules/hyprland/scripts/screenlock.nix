{ pkgs, ... }:
let
  # hyprlock now captures its own per-output screenshot (path = "screenshot"
  # in hyprlock.nix), so this wrapper just launches it. Kept as its own command
  # so the keybind / future pre-lock hooks have a stable entry point.
  screenlock = pkgs.writeShellScriptBin "screenlock" ''
    hyprlock
  '';
in
{
  home.packages = [ screenlock ];
}

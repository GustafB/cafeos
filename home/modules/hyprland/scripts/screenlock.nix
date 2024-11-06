{ pkgs, ... }:
let
  screenlock = pkgs.writeShellScriptBin "screenlock" ''
    grim -o DP-3 -l 0 /tmp/screenlock_0.png &
    grim -o DP-4 -l 0 /tmp/screenlock_1.png &
    hyprlock
  '';
in
{
  home.packages = [ screenlock ];
}

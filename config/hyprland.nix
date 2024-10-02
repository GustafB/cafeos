{
  lib,
  ...
}:

with lib;
{
  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;
    systemd = {
      enable = true;
      variables = ["--all"];
    };
    extraConfig =
      let
        modifier = "ALT";
        terminal = "kitty";
      in
      concatStrings [
  ''
    env = NIXOS_OZONE_WL, 1
    env = NIXPKGS_ALLOW_UNFREE, 1
    env = XDG_CURRENT_DESKTOP, Hyprland
    env = XDG_SESSION_DESKTOP, Hyprland
    env = XDG_SESSION_TYPE, wayland
    env = GDK_BACKEND, wayland, x11
    env = CLUTTER_BACKEND, wayland
    env = QT_QPA_PLATFORM=wayland;xcb
    env = QT_WAYLAND_DISABLE_WINDOWDECORATION, 1
    env = QT_AUTO_SCREEN_SCALE_FACTOR, 1
    exec-once = systemctl --user import-environment QT_QPA_PLATFORMTHEME WAYLAND_DISPLAY XDG_CURRENT_DESKTOP
    exec-once = killall -q swww;sleep .5 && swww init
    exec-once = killall -q waybar;sleep .5 && waybar 
    monitor=,preferred,auto,1
      
    input {
    kb_options = grp:alt_shift_toggle
    kb_options = caps:super
    follow_mouse = 1
    touchpad {
    natural_scroll = true
    disable_while_typing = true
    scroll_factor = 0.8
    }
    
    bind = ${modifier},Return,exec,${terminal}
    bind = ${modifier}SHIFT,Return,exec,rofi-launcher
    }
  ''
      ];
  };
}

{
  lib,
  username,
  host,
  config,
  ...
}:

let
  inherit (import ../hosts/${host}/variables.nix)
  browser
  terminal
  monitorSettings
  keyboardLayout
  ;
in

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
      in
      concatStrings [
  ''
    env = NIXOS_OZONE_WL, 1
    env = NIXPKGS_ALLOW_UNFREE, 1
    env = XDG_CURRENT_DESKTOP, Hyprland
    env = XDG_SESSION_DESKTOP, Hyprland
    env = XDG_SESSION_TYPE, wayland
    env = GDK_BACKEND, wayland
    env = CLUTTER_BACKEND, wayland
    env = QT_QPA_PLATFORM=wayland;xcb
    env = QT_WAYLAND_DISABLE_WINDOWDECORATION, 1
    env = QT_AUTO_SCREEN_SCALE_FACTOR, 1
    env = MOZ_ENABLE_WAYLAND, 1
    env = SDL_VIDEODRIVER, wayland
    exec-once = systemctl --user import-environment QT_QPA_PLATFORMTHEME WAYLAND_DISPLAY XDG_CURRENT_DESKTOP
    exec-once = killall -q swww;sleep .5 && swww init
    exec-once = killall -q waybar;sleep .5 && waybar 
    exec-once = lxqt-policykit-agent
    monitor=,preferred,auto,1
    ${monitorSettings} 
    input {
      kb_layout = ${keyboardLayout}
      kb_options = grp:alt_shift_toggle
      kb_options = ctrl:nocaps
      follow_mouse = 1
      touchpad {
        natural_scroll = true
        disable_while_typing = true
        scroll_factor = 0.8
      }
    
      bind = ${modifier},Return,exec,${terminal}
      bind = ${modifier}SHIFT,Return,exec,rofi-launcher
      bind = ${modifier},Q,killactive,
      bind = ${modifier}SHIFT,C,exit,
      bind = ${modifier}SHIFT,F,togglefloating,
      bind = ${modifier}SHIFT,I,togglesplit,

      # workspace movement
      bind = ${modifier}SHIFT,left,movewindow,l
      bind = ${modifier}SHIFT,right,movewindow,r
      bind = ${modifier}SHIFT,up,movewindow,u
      bind = ${modifier}SHIFT,down,movewindow,d
      bind = ${modifier}SHIFT,h,movewindow,l
      bind = ${modifier}SHIFT,l,movewindow,r
      bind = ${modifier}SHIFT,j,movewindow,u
      bind = ${modifier}SHIFT,k,movewindow,d
      bind = ${modifier}SHIFT,left,movefocus,l
      bind = ${modifier}SHIFT,right,movefocus,r
      bind = ${modifier}SHIFT,up,movefocus,u
      bind = ${modifier}SHIFT,down,movefocus,d
      bind = ${modifier},h,movefocus,l
      bind = ${modifier},l,movefocus,r
      bind = ${modifier},j,movefocus,u
      bind = ${modifier},k,movefocus,d
      bind = ${modifier},1,workspace,1
      bind = ${modifier},2,workspace,2
      bind = ${modifier},3,workspace,3
      bind = ${modifier},4,workspace,4
      bind = ${modifier},5,workspace,5
      bind = ${modifier},6,workspace,6
      bind = ${modifier},7,workspace,7
      bind = ${modifier},8,workspace,8
      bind = ${modifier},9,workspace,9
      bind = ${modifier},0,workspace,10
      bind = ${modifier}SHIFT,1,movetoworkspace,1
      bind = ${modifier}SHIFT,2,movetoworkspace,2
      bind = ${modifier}SHIFT,3,movetoworkspace,3
      bind = ${modifier}SHIFT,4,movetoworkspace,4
      bind = ${modifier}SHIFT,5,movetoworkspace,5
      bind = ${modifier}SHIFT,6,movetoworkspace,6
      bind = ${modifier}SHIFT,7,movetoworkspace,7
      bind = ${modifier}SHIFT,8,movetoworkspace,8
      bind = ${modifier}SHIFT,9,movetoworkspace,9
      bind = ${modifier}SHIFT,0,movetoworkspace,10
      bind = ALT,Tab,cyclenext
      bind = ALT,Tab,bringactivetotop
    }
  ''
      ];
  };
}

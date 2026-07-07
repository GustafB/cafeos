{
  lib,
  vars,
  ...
}:

let
  inherit (vars)
    terminal
    monitorSettings
    keyboardLayout
    ;
in

with lib;
{
  imports = [
    ./assets
  ];

  custom.assets = {
    enable = true;
    assetsPath = ./assets;
  };

  wayland.windowManager.hyprland = {
    enable = true;
    # Keep the legacy hyprlang config format explicitly (the home-manager
    # default flips to "lua" at stateVersion 26.05); this config is hyprlang.
    configType = "hyprlang";
    xwayland = {
      enable = true;
    };
    systemd = {
      enable = true;
      variables = [ "--all" ];
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
          env = QT_QPA_PLATFORM, wayland;xcb
          env = QT_WAYLAND_DISABLE_WINDOWDECORATION, 1
          env = QT_AUTO_SCREEN_SCALE_FACTOR, 1
          env = MOZ_ENABLE_WAYLAND, 1
          env = SDL_VIDEODRIVER, wayland
          exec-once = systemctl --user import-environment QT_QPA_PLATFORMTHEME WAYLAND_DISPLAY XDG_CURRENT_DESKTOP
          exec-once = eww daemon && eww open bar
          exec-once = wl-paste --watch cliphist store
          exec-once = lxqt-policykit-agent
          exec-once = 1password --silent
          exec-once = hypridle
          exec-once = hyprlock
          monitor=,preferred,auto,1
          ${monitorSettings} 


          general {
              gaps_in = 5
              # smaller top gap: bar has its own 8px margin, keeps islands visually centered
              gaps_out = 8, 20, 20, 20
              border_size = 2
              resize_on_border = true
              layout = dwindle
          }

          decoration {
              rounding = 15

              blur {
                  enabled = true
                  size = 12
                  passes = 4
                  new_optimizations = true
              }

              shadow {
                  enabled = true
                  range = 30
                  render_power = 4
                  color = rgb(000000)
              }
          }

          animations {
              enabled = yes
              bezier = quart, 0.25, 1, 0.5, 1
              animation = windows, 1, 6, quart, slide
              animation = border, 1, 6, quart
              animation = fade, 1, 6, quart
              animation = workspaces, 1, 6, quart
          }

          dwindle {
              preserve_split = yes
          }

          misc {
              disable_hyprland_logo = true
          }

          # frosted glass for eww (gtk-layer-shell), rofi and mako
          # (notifications); ignore_alpha skips the transparent parts of each
          # layer surface so only the rgba panels/islands get the backdrop blur
          layerrule = blur on, ignore_alpha 0.3, match:namespace ^(gtk-layer-shell|rofi|notifications)$
          # dim the desktop behind rofi menus for focus/depth
          layerrule = dim_around on, match:namespace ^(rofi)$

          # 0.55 rule grammar: comma-separated "field value" pairs + match:
          # (plain "float class:..." parses as ok but never matches)
          windowrule = float on, pin on, size 900 500, match:class ^(pavucontrol)$

          # scratchpad terminal: floating, centered on the special workspace
          windowrule = float on, size 1400 800, center on, match:class ^(kitty-scratch)$

          xwayland {
            force_zero_scaling = true
          }


          input {
            kb_layout = ${keyboardLayout}
            kb_options = ctrl:nocaps
            follow_mouse = 1
            touchpad {
              natural_scroll = true
              disable_while_typing = true
              scroll_factor = 0.8
            }
          }

          bind = ${modifier},Return,exec,${terminal}
            bind = ${modifier}SHIFT,Return,exec,rofi-launcher
            bind = ${modifier},Q,killactive,
            bind = ${modifier}SHIFT,C,exit,
            bind = ${modifier}SHIFT,F,togglefloating,
            bind = ${modifier}SHIFT,I,layoutmsg,togglesplit
            bind = ${modifier}CTRL,l,exec,screenlock
            bind = ${modifier},slash,exec,eww open --toggle cheatsheet
            bind = ${modifier},grave,exec,bash ~/.config/eww/scripts/cc-toggle.sh

            # hardware fn keys (l = works while locked, e = repeats on hold);
            # route through the eww scripts so keys, bar and control center
            # share one implementation (5% steps, volume cap, active player)
            bindel = ,XF86AudioRaiseVolume,exec,bash ~/.config/eww/scripts/volume.sh scroll up
            bindel = ,XF86AudioLowerVolume,exec,bash ~/.config/eww/scripts/volume.sh scroll down
            bindl = ,XF86AudioMute,exec,bash ~/.config/eww/scripts/volume.sh toggle
            bindl = ,XF86AudioMicMute,exec,wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle
            bindel = ,XF86MonBrightnessUp,exec,bash ~/.config/eww/scripts/brightness.sh step +5
            bindel = ,XF86MonBrightnessDown,exec,bash ~/.config/eww/scripts/brightness.sh step -5
            bindl = ,XF86AudioPlay,exec,bash ~/.config/eww/scripts/mediacontrol.sh --playpause
            bindl = ,XF86AudioNext,exec,bash ~/.config/eww/scripts/mediacontrol.sh --next
            bindl = ,XF86AudioPrev,exec,bash ~/.config/eww/scripts/mediacontrol.sh --prev

            # drop-down scratchpad terminal on the special workspace
            # (script respawns/retrieves the window if closed or moved away)
            bind = ${modifier},S,exec,scratchpad

            # applets (rofi)
            bind = ${modifier},D,exec,appswitcher
            bind = ${modifier},V,exec,clipmenu
            bind = ${modifier}SHIFT,E,exec,powermenu
            bind = ${modifier}SHIFT,W,exec,wallpaper-menu
            bind = ${modifier}SHIFT,N,exec,network-menu
            bind = ${modifier}SHIFT,D,exec,dnd-toggle
            bind = ,Print,exec,screenshot

            # workspace movement
            bind = ${modifier}SHIFT,left,movewindow,l
            bind = ${modifier}SHIFT,right,movewindow,r
            bind = ${modifier}SHIFT,up,movewindow,u
            bind = ${modifier}SHIFT,down,movewindow,d
            bind = ${modifier}SHIFT,h,movewindow,l
            bind = ${modifier}SHIFT,l,movewindow,r
            bind = ${modifier}SHIFT,j,movewindow,u
            bind = ${modifier}SHIFT,k,movewindow,d
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
            bind = ALT,Tab,exec,appswitcher
            # quick flip to previous window (picker needs Alt released first)
            bind = ALTSHIFT,Tab,focuscurrentorlast,

            # mouse drag on floats: mod+LMB move, mod+RMB resize
            bindm = ${modifier},mouse:272,movewindow
            bindm = ${modifier},mouse:273,resizewindow

            # resize/move mode: mod+R, then h/j/k/l or arrows to resize,
            # shift+h/j/k/l to move floats (held keys repeat);
            # j/k follow the movefocus convention above (j=up, k=down)
            bind = ${modifier},R,submap,resize
            submap = resize
            ${concatMapStrings (
              d: ''
                binde = ,${d.key},resizeactive,${d.delta}
                            binde = ,${d.arrow},resizeactive,${d.delta}
                            binde = SHIFT,${d.key},moveactive,${d.delta}
                            binde = SHIFT,${d.arrow},moveactive,${d.delta}
              ''
            ) [
              { key = "h"; arrow = "left";  delta = "-40 0"; }
              { key = "l"; arrow = "right"; delta = "40 0"; }
              { key = "j"; arrow = "up";    delta = "0 -40"; }
              { key = "k"; arrow = "down";  delta = "0 40"; }
            ]}
            bind = ,escape,submap,reset
            bind = ,Return,submap,reset
            bind = ${modifier},R,submap,reset
            submap = reset
        ''
      ];
  };
}

{
    pkgs,
    lib,
    host,
    config,
    ...
}:
let
    inherit (import ../hosts/${host}/variables.nix);
in
with lib;
{
    programs.waybar = {
        enable = true;
        package = pkgs.waybar;
        settings = [
        {
            layer = "top";
            modules-left = [ 
                "cpu" 
                "memory"
                "disk"
                "pulseaudio"
            ];
            modules-center = [
                "hyprland/window" 
            ];
            modules-right = [
                "tray"
                "clock"
            ];

            # should wrap window in workspaces (slider)
            "hyprland/workspaces" = {
                format = "{name}";
                format-icons = {
                    "default" = "○";
                    "active" = "◉";
                    "urgent" = "◉";
                };
                on-scroll-up = "hyprctl dispatch workspace e+1";
                on-scroll-down = "hyprctl dispatch workspace e-1";
            };

            "pulseaudio" = {
                format = "{icon} {volume}% {format_source}";
                format-bluetooth = "{volume}% {icon} {format_source}";
                format-bluetooth-muted = " {icon} {format_source}";
                format-muted = " {format_source}";
                format-source = " {volume}%";
                format-source-muted = "";
                format-icons = {
                    headphone = "";
                    hands-free = "";
                    headset = "";
                    phone = "";
                    portable = "";
                    car = "";
                    default = [
                        ""
                        ""
                        ""
                    ];
                };
                on-click = "sleep 0.1 && pavucontrol";
            };

            "memory" = {
                interval = 5;
                format = " {}%";
                tooltip = true;
            };
            "cpu" = {
                interval = 5;
                format = " {usage:2}%";
                tooltip = true;
            };
            "disk" = {
                format = " {free}";
                tooltip = true;
            };
            "network" = {
                format-icons = [
                    "󰤯"
                    "󰤟"
                    "󰤢"
                    "󰤥"
                    "󰤨"
                ];
                format-ethernet = " {bandwidthDownOctets}";
                format-wifi = "{icon} {signalStrength}%";
                format-disconnected = "󰤮";
                tooltip = false;
            };
            "tray" = {
                spacing = 12;
            };

        }
        ];
    };
}


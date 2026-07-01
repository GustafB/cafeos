{
  pkgs,
  config,
  ...
}:
let
  # Tokyo Night palette from the central stylix theme, with leading '#'.
  # Single source of truth: change the scheme in modules/config/stylix.nix and
  # this bar follows automatically.
  c = config.lib.stylix.colors.withHashtag;

  script = name: {
    source = ./scripts/${name};
    executable = true;
  };
in
{
  programs.eww = {
    enable = true;
    package = pkgs.eww;
  };

  # Backends the widgets shell out to. wpctl (wireplumber) and nmcli
  # (networkmanager) come from the system; these are the rest.
  home.packages = with pkgs; [
    socat # hyprland IPC event stream (workspaces/window)
    jq # JSON plumbing in the scripts
    brightnessctl # backlight control
  ];

  xdg.configFile = {
    "eww/eww.yuck".source = ./eww.yuck;

    "eww/scripts/workspaces.sh" = script "workspaces.sh";
    "eww/scripts/window.sh" = script "window.sh";
    "eww/scripts/volume.sh" = script "volume.sh";
    "eww/scripts/brightness.sh" = script "brightness.sh";
    "eww/scripts/battery.sh" = script "battery.sh";
    "eww/scripts/wifi.sh" = script "wifi.sh";

    # Generated from the palette so the bar restyles with the rest of the desktop.
    "eww/eww.scss".text = ''
      * {
        all: unset;
        font-family: "JetBrainsMono Nerd Font Mono";
        font-size: 13px;
      }

      .bar { background-color: transparent; padding: 4px 10px; }

      /* floating islands */
      .island {
        background-color: ${c.base01};
        color: ${c.base05};
        border-radius: 12px;
        padding: 2px 12px;
        margin: 0 3px;
      }
      .ico { color: ${c.base0D}; font-size: 15px; }

      .ws { padding: 2px 8px; }
      .ws-btn { color: ${c.base03}; padding: 0 4px; }
      .ws-btn.occupied { color: ${c.base04}; }
      .ws-btn.active { color: ${c.base0D}; }

      .win-title { color: ${c.base04}; font-style: italic; }
      .clock label { color: ${c.base05}; font-weight: bold; }

      .bat-ico { color: ${c.base0B}; }
      .net-ico { color: ${c.base0C}; }
      .vol-ico { color: ${c.base0E}; }
      .tray { padding: 2px 10px; }

      /* popups */
      .popup {
        background-color: ${c.base00};
        border: 2px solid ${c.base02};
        border-radius: 16px;
        padding: 16px;
        margin: 6px;
      }
      .popup-title { color: ${c.base0D}; font-weight: bold; }

      .slider trough {
        background-color: ${c.base02};
        border-radius: 12px;
        min-height: 8px;
        min-width: 150px;
      }
      .slider highlight { background-color: ${c.base0D}; border-radius: 12px; }
      .slider slider {
        background-color: ${c.base05};
        border-radius: 50%;
        min-height: 15px;
        min-width: 15px;
        margin: -5px 0;
      }

      .cal { padding: 6px; color: ${c.base05}; }
      .cal:selected { background-color: ${c.base0D}; color: ${c.base00}; border-radius: 6px; }
      .cal:indeterminate { color: ${c.base03}; }
      .cal .header { color: ${c.base0D}; font-weight: bold; }

      .refresh { color: ${c.base0D}; padding: 0 6px; font-size: 15px; }
      .wifi-item {
        padding: 8px 10px;
        border-radius: 8px;
        color: ${c.base05};
      }
      .wifi-item:hover { background-color: ${c.base01}; }
      .wifi-item.active { color: ${c.base0B}; }
      .wifi-item .sig { color: ${c.base03}; }
      .wifi-connect { padding: 8px 10px 4px 10px; }
      .wifi-pass {
        background-color: ${c.base01};
        color: ${c.base05};
        border: 1px solid ${c.base02};
        border-radius: 8px;
        padding: 6px 10px;
      }
      .connect-btn {
        background-color: ${c.base0D};
        color: ${c.base00};
        font-weight: bold;
        border-radius: 8px;
        padding: 7px;
      }
      .connect-btn:hover { background-color: ${c.base0C}; }
    '';
  };
}

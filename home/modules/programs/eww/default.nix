{
  pkgs,
  config,
  ...
}:
let
  # Palette from the central stylix theme, with leading '#'. Single source of
  # truth: vars.wallpaper -> stylix derived scheme (modules/config/stylix.nix).
  c = config.lib.stylix.colors.withHashtag;

  # rgba() from the palette, for the glass surfaces. Hyprland blurs what's
  # behind them (layerrule blur on gtk-layer-shell), the alpha lets it show.
  raw = config.lib.stylix.colors;
  rgba = base: a: "rgba(${raw."${base}-rgb-r"}, ${raw."${base}-rgb-g"}, ${raw."${base}-rgb-b"}, ${a})";

  scripts = [
    "workspaces.sh"
    "window.sh"
    "volume.sh"
    "brightness.sh"
    "battery.sh"
    "wifi.sh"
    "bluetooth.sh"
    "airplane.sh"
    "nightlight.sh"
    "gamemode.sh"
    "mediacontrol.sh"
    "notifications.sh"
  ];
  widgets = [
    "controlcenter.yuck"
    "player.yuck"
    "cheatsheet.yuck"
  ];

  scriptFiles = builtins.listToAttrs (map (name: {
    name = "eww/scripts/${name}";
    value = {
      source = ./scripts/${name};
      executable = true;
    };
  }) scripts);

  widgetFiles = builtins.listToAttrs (map (name: {
    name = "eww/widgets/${name}";
    value.source = ./widgets/${name};
  }) widgets);
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
    playerctl # music player (MPRIS) control
    wlsunset # night light toggle
    bluez # bluetoothctl for the bluetooth toggle
    curl # album-art fetch in mediacontrol.sh
  ];

  xdg.configFile = {
    "eww/eww.yuck".source = ./eww.yuck;
  }
  // scriptFiles
  // widgetFiles
  // {
    # Generated from the palette so the bar restyles with the rest of the desktop.
    "eww/eww.scss".text = ''
      * {
        all: unset;
        font-family: "JetBrainsMono Nerd Font Mono";
        font-size: 13px;
      }

      .bar { background-color: transparent; padding: 4px 10px; }

      /* strip GTK button chrome (background-image survives all:unset) */
      button {
        background-color: transparent;
        background-image: none;
        border: none;
        box-shadow: none;
        outline: none;
      }

      .island {
        background-color: ${rgba "base02" "0.55"};
        background-image: linear-gradient(170deg, rgba(255, 255, 255, 0.08), rgba(255, 255, 255, 0) 45%);
        border: 1px solid rgba(255, 255, 255, 0.07);
        box-shadow: 0 3px 10px rgba(0, 0, 0, 0.35);
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
      .tray { padding: 0 6px; }

      /* popups */
      .popup {
        background-color: ${rgba "base00" "0.65"};
        background-image: linear-gradient(170deg, rgba(255, 255, 255, 0.05), rgba(255, 255, 255, 0) 50%);
        border: 1px solid rgba(255, 255, 255, 0.12);
        box-shadow: 0 12px 32px rgba(0, 0, 0, 0.5);
        border-radius: 16px;
        padding: 16px;
        margin: 6px;
      }
      .popup-title { color: ${c.base0D}; font-weight: bold; }

      .slider trough {
        background-color: ${rgba "base02" "0.6"};
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

      .metric-val { color: ${c.base05}; }
      .metric-ico { font-size: 14px; }
      .metric-ico.cpu  { color: ${c.base0B}; }
      .metric-ico.ram  { color: ${c.base0D}; }
      .metric-ico.disk { color: ${c.base0E}; }

      .launcher { padding: 2px 10px; }
      .launcher-ico { color: ${c.base0D}; font-size: 16px; }
      .launcher:hover .launcher-ico { color: ${c.base0C}; }

      .media-ico { color: ${c.base0E}; }
      .media-title { color: ${c.base05}; font-style: italic; }

      /* control center - surface-dots "hub" style card panel */
      .cc-root {
        background-color: ${rgba "base00" "0.55"};
        background-image: linear-gradient(165deg, rgba(255, 255, 255, 0.05), rgba(255, 255, 255, 0) 55%);
        border: 1px solid rgba(255, 255, 255, 0.12);
        box-shadow: 0 12px 36px rgba(0, 0, 0, 0.55);
        border-radius: 18px;
        padding: 12px;
        /* transparent gutter so the drop shadow isn't clipped at the window edge */
        margin: 2px 12px 30px 12px;
      }
      .cc-card {
        background-color: ${rgba "base01" "0.45"};
        background-image: linear-gradient(170deg, rgba(255, 255, 255, 0.05), rgba(255, 255, 255, 0) 40%);
        border: 1px solid rgba(255, 255, 255, 0.06);
        box-shadow: 0 4px 12px rgba(0, 0, 0, 0.28);
        border-radius: 14px;
        padding: 12px;
      }

      /* header */
      .cc-avatar {
        background-color: ${c.base0D};
        background-image: linear-gradient(rgba(255, 255, 255, 0.22), rgba(255, 255, 255, 0) 60%);
        box-shadow: 0 3px 12px ${rgba "base0D" "0.4"};
        border-radius: 12px;
        min-width: 40px;
        min-height: 40px;
      }
      .cc-avatar-ico { color: ${c.base00}; font-size: 22px; }
      .cc-user { color: ${c.base05}; font-size: 15px; font-weight: bold; }
      .cc-host { color: ${c.base04}; font-size: 12px; }

      /* small round header buttons */
      .cc-mini {
        background-color: ${rgba "base02" "0.6"};
        border: 1px solid rgba(255, 255, 255, 0.06);
        border-radius: 10px;
        min-width: 30px;
        min-height: 30px;
      }
      .cc-mini:hover { background-color: ${rgba "base03" "0.75"}; }
      .cc-mini.active {
        background-color: ${c.base0D};
        background-image: linear-gradient(rgba(255, 255, 255, 0.2), rgba(255, 255, 255, 0) 60%);
        box-shadow: 0 2px 8px ${rgba "base0D" "0.4"};
      }
      .cc-mini.active .cc-mini-ico { color: ${c.base00}; }
      .cc-mini-ico { color: ${c.base05}; font-size: 14px; }
      .cc-mini-power:hover, .cc-mini-power.open { background-color: ${c.base08}; }
      .cc-mini-power:hover .cc-mini-ico,
      .cc-mini-power.open .cc-mini-ico { color: ${c.base00}; }

      /* expandable power menu */
      .cc-power-menu { margin-top: 12px; }
      .cc-uptime { color: ${c.base04}; font-size: 11px; margin-bottom: 2px; }
      .cc-pow {
        background-color: ${rgba "base02" "0.6"};
        border: 1px solid transparent;
        border-radius: 12px;
        padding: 10px 0;
      }
      .cc-pow:hover {
        background-color: ${rgba "base03" "0.75"};
        border-color: ${c.base0D};
        box-shadow: 0 2px 10px ${rgba "base0D" "0.3"};
      }
      .cc-pow:hover .cc-pow-ico { color: ${c.base0D}; }
      .cc-pow.danger:hover { border-color: ${c.base08}; box-shadow: 0 2px 10px ${rgba "base08" "0.35"}; }
      .cc-pow.danger:hover .cc-pow-ico { color: ${c.base08}; }
      .cc-pow-ico { color: ${c.base05}; font-size: 18px; }
      .cc-pow-label { color: ${c.base04}; font-size: 10px; }

      /* quick toggle pills */
      .cc-quick { min-width: 195px; }
      .cc-pill {
        background-color: ${rgba "base02" "0.6"};
        border: 1px solid transparent;
        border-radius: 12px;
        padding: 8px 10px;
      }
      .cc-pill:hover { background-color: ${rgba "base03" "0.75"}; }
      .cc-pill.active {
        background-color: ${c.base0D};
        background-image: linear-gradient(rgba(255, 255, 255, 0.18), rgba(255, 255, 255, 0) 55%);
        box-shadow: 0 3px 12px ${rgba "base0D" "0.45"};
      }
      .cc-pill.active .cc-pill-ico,
      .cc-pill.active .cc-pill-label { color: ${c.base00}; }
      .cc-pill-ico { color: ${c.base05}; font-size: 15px; }
      .cc-pill-label { color: ${c.base04}; font-size: 11px; }

      /* chunky vertical sliders */
      .cc-vslider trough {
        background-color: ${rgba "base02" "0.6"};
        border-radius: 12px;
        min-width: 38px;
        min-height: 140px;
      }
      .cc-vslider highlight {
        background-color: ${c.base0D};
        background-image: linear-gradient(90deg, rgba(255, 255, 255, 0.15), rgba(255, 255, 255, 0) 70%);
        box-shadow: 0 2px 10px ${rgba "base0D" "0.35"};
        border-radius: 12px;
      }
      .cc-vslider slider {
        background-color: transparent;
        min-width: 0;
        min-height: 0;
        margin: 0;
        padding: 0;
      }
      .cc-vslider-ico { color: ${c.base04}; font-size: 14px; }

      /* game/caffeine chips */
      .cc-chip {
        background-color: ${rgba "base02" "0.6"};
        border: 1px solid rgba(255, 255, 255, 0.06);
        border-radius: 10px;
        padding: 6px 12px;
      }
      .cc-chip:hover { background-color: ${rgba "base03" "0.75"}; }
      .cc-chip.active {
        background-color: ${c.base0D};
        background-image: linear-gradient(rgba(255, 255, 255, 0.18), rgba(255, 255, 255, 0) 55%);
        box-shadow: 0 2px 10px ${rgba "base0D" "0.4"};
      }
      .cc-chip.active .cc-chip-ico,
      .cc-chip.active .cc-chip-label { color: ${c.base00}; }
      .cc-chip-ico { color: ${c.base05}; font-size: 13px; }
      .cc-chip-label { color: ${c.base04}; font-size: 11px; }

      /* system stats rings */
      .cc-cring { background-color: ${rgba "base02" "0.6"}; color: ${c.base03}; }
      .cc-cring.cpu  { color: ${c.base0B}; }
      .cc-cring.ram  { color: ${c.base0D}; }
      .cc-cring.disk { color: ${c.base0E}; }
      .cc-cring-inner { min-width: 52px; min-height: 52px; }
      .cc-cring-ico { color: ${c.base05}; font-size: 20px; }
      .cc-cring-val { color: ${c.base04}; font-size: 12px; }

      /* notifications */
      .cc-notif-title { color: ${c.base05}; font-size: 13px; font-weight: bold; }
      .cc-notif {
        background-color: ${rgba "base02" "0.6"};
        border-radius: 10px;
        padding: 8px 10px;
      }
      .cc-notif-app { color: ${c.base0D}; font-size: 10px; font-weight: bold; }
      .cc-notif-summary { color: ${c.base05}; font-size: 12px; font-weight: bold; }
      .cc-notif-body { color: ${c.base04}; font-size: 11px; }
      .cc-notif-empty { color: ${c.base03}; font-size: 12px; padding: 8px 0; }

      /* music player */
      .mc-root { padding: 4px; }
      .mc-art {
        background-color: ${rgba "base02" "0.6"};
        background-size: cover;
        background-position: center;
        border-radius: 12px;
        min-width: 96px;
        min-height: 96px;
      }
      .mc-art-fallback { color: ${c.base04}; font-size: 34px; }
      .mc-title { color: ${c.base05}; font-size: 14px; font-weight: bold; }
      .mc-artist { color: ${c.base04}; font-size: 12px; }
      .mc-time { color: ${c.base03}; font-size: 10px; }
      .mc-seek trough {
        background-color: ${rgba "base02" "0.6"}; border-radius: 12px;
        min-height: 6px; min-width: 180px;
      }
      .mc-seek highlight { background-color: ${c.base0D}; border-radius: 12px; }
      .mc-seek slider {
        background-color: ${c.base05}; border-radius: 50%;
        min-height: 12px; min-width: 12px; margin: -4px 0;
      }
      .mc-btn { color: ${c.base05}; font-size: 20px; padding: 0 2px; }
      .mc-btn:hover { color: ${c.base0D}; }
      .mc-sm { font-size: 14px; color: ${c.base04}; }
      .mc-sm.active { color: ${c.base0D}; }
      .mc-play { color: ${c.base0D}; font-size: 24px; }

      /* cheatsheet */
      .cs-popup { padding: 22px 26px; }
      .cs-root { min-width: 660px; }
      .cs-heading { color: ${c.base0D}; font-size: 16px; font-weight: bold; margin-bottom: 12px; }
      .cs-section { color: ${c.base0E}; font-size: 12px; font-weight: bold; margin: 10px 0 4px 0; }
      .cs-row { padding: 2px 0; }
      .cs-key { color: ${c.base0C}; font-size: 12px; }
      .cs-act { color: ${c.base04}; font-size: 12px; }
    '';
  };
}

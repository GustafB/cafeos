{
  pkgs,
  config,
  ...
}:
let
  # Tokyo Night palette from Stylix, shared by every rofi applet theme via
  # an @import "shared.rasi". Single source of truth = modules/config/stylix.nix.
  c = config.lib.stylix.colors.withHashtag;
  themeDir = "${config.xdg.configHome}/rofi/themes";

  # ── applet scripts (Wayland-native; gh0stzk's were X11/bspwm) ────────────
  powermenu = pkgs.writeShellScriptBin "powermenu" ''
    lock="󰌾"; logout="󰗽"; suspend="󰤄"; reboot="󰜉"; poweroff="󰐥"
    chosen=$(printf '%s\n%s\n%s\n%s\n%s\n' \
      "$lock" "$suspend" "$logout" "$reboot" "$poweroff" \
      | rofi -dmenu -p "Goodbye $USER" \
             -mesg "Uptime: $(uptime -p | sed 's/^up //')" \
             -theme ${themeDir}/powermenu.rasi)
    case "$chosen" in
      "$lock")     screenlock ;;
      "$suspend")  systemctl suspend ;;
      "$logout")   hyprctl dispatch exit ;;
      "$reboot")   systemctl reboot ;;
      "$poweroff") systemctl poweroff ;;
    esac
  '';

  screenshot = pkgs.writeShellScriptBin "screenshot" ''
    dir="''${XDG_PICTURES_DIR:-$HOME/Pictures}/Screenshots"
    mkdir -p "$dir"
    file="$dir/Shot-$(date +%Y-%m-%d-%H%M%S).png"

    full="";  region="󰩭";  window="󰖯";  timed="󰔝";  allmon="󰍹"
    choice=$(printf '%s\n%s\n%s\n%s\n%s\n' \
      "$full" "$region" "$window" "$timed" "$allmon" \
      | rofi -dmenu -p Screenshot -mesg "→ $dir" \
             -theme ${themeDir}/screenshot.rasi)
    [ -z "$choice" ] && exit 0

    mon() { hyprctl monitors -j | jq -r '.[] | select(.focused) | .name'; }
    shoot() { grim "$@" "$file"; }

    case "$choice" in
      "$full")   shoot -o "$(mon)" ;;
      "$region") geo=$(slurp) || exit 0; shoot -g "$geo" ;;
      "$window") geo=$(hyprctl activewindow -j \
                   | jq -r '"\(.at[0]),\(.at[1]) \(.size[0])x\(.size[1])"'); shoot -g "$geo" ;;
      "$timed")  sleep 3; shoot -o "$(mon)" ;;
      "$allmon") shoot ;;
    esac

    if [ -f "$file" ]; then
      wl-copy -t image/png <"$file"
      notify-send -i "$file" "Screenshot" "Saved and copied to clipboard"
    else
      notify-send "Screenshot" "Cancelled"
    fi
  '';

  clipmenu = pkgs.writeShellScriptBin "clipmenu" ''
    cliphist list \
      | rofi -dmenu -i -p " Clipboard" -theme ${themeDir}/list.rasi \
      | cliphist decode \
      | wl-copy
  '';

  appswitcher = pkgs.writeShellScriptBin "appswitcher" ''
    # tab-separated "address<TAB>class: title"; show only the label, but map the
    # choice back by index (-format i) so we never have to parse it out again.
    mapfile -t rows < <(hyprctl clients -j \
      | jq -r '.[] | select(.title != "" and .mapped) | "\(.address)\t\(.class): \(.title)"')
    [ "''${#rows[@]}" -eq 0 ] && exit 0
    idx=$(printf '%s\n' "''${rows[@]}" | cut -f2- \
      | rofi -dmenu -i -p " Windows" -format i -theme ${themeDir}/list.rasi)
    [ -z "$idx" ] && exit 0
    addr=$(printf '%s' "''${rows[$idx]}" | cut -f1)
    [ -n "$addr" ] && hyprctl dispatch focuswindow "address:$addr"
  '';

  # networkmanager_dmenu reads ~/.config/networkmanager-dmenu/config.ini for
  # its rofi invocation (see xdg.configFile below); this is just a stable name.
  network-menu = pkgs.writeShellScriptBin "network-menu" ''
    exec ${pkgs.networkmanager_dmenu}/bin/networkmanager_dmenu "$@"
  '';
in
{
  home.packages = with pkgs; [
    grim # screenshot capture
    slurp # region selection
    wl-clipboard # wl-copy / wl-paste
    cliphist # clipboard history store
    libnotify # notify-send (mako renders it)
    networkmanager_dmenu # full NetworkManager rofi menu
    powermenu
    screenshot
    clipmenu
    appswitcher
    network-menu
  ];

  xdg.configFile = {
    "rofi/themes/powermenu.rasi".source = ./themes/powermenu.rasi;
    "rofi/themes/screenshot.rasi".source = ./themes/screenshot.rasi;
    "rofi/themes/list.rasi".source = ./themes/list.rasi;

    # Palette-driven colours every applet theme @imports.
    "rofi/themes/shared.rasi".text = ''
      * {
          font:             "JetBrainsMono Nerd Font Bold 11";
          background:       ${c.base00};
          background-alt:   ${c.base01};
          bg-alt:           ${c.base01};
          foreground:       ${c.base05};
          selected:         ${c.base0D};
          active:           ${c.base0B};
          urgent:           ${c.base08};
      }
    '';

    "networkmanager-dmenu/config.ini".text = ''
      [dmenu]
      dmenu_command = rofi -theme ${themeDir}/list.rasi
      rofi_highlight = True
      compact = True
      wifi_chars = ▁▂▄▆█

      [editor]
      terminal = kitty
    '';
  };
}

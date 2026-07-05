{
  username,
  host,
  config,
  ...
}:
let
  # empty monitor = render on every output, so the lock screen works on any
  # host (multi-monitor desktop or single-panel laptop).
  primary = "";

  # Palette from Stylix (single source: modules/config/stylix.nix).
  c = config.lib.stylix.colors; # hex without '#', hyprlock wants rgb(RRGGBB)
  rgba = base: a: "rgba(${c."${base}-rgb-r"}, ${c."${base}-rgb-g"}, ${c."${base}-rgb-b"}, ${a})";
in
{
  # Stylix's hyprlock target would override the screenshot background; we pull
  # the palette in ourselves instead.
  stylix.targets.hyprlock.enable = false;

  programs.hyprlock = {
    enable = true;
    settings = {
      general = {
        disable_loading_bar = true;
        hide_cursor = true;
        no_fade_in = false;
      };

      background = [
        {
          monitor = "";
          # hyprlock captures a live screenshot of each output itself; blur +
          # darken = the same frosted-glass backdrop as the rest of the rice.
          path = "screenshot";
          blur_passes = 4;
          blur_size = 8;
          brightness = 0.55;
          new_optimizations = true;
        }
      ];

      label = [
        {
          # date, top left
          monitor = "${primary}";
          text = ''cmd[update:60000] date +"%A, %-d %B"'';
          color = "rgb(${c.base05})";
          font_family = "JetBrainsMono Nerd Font Mono";
          font_size = 20;
          position = "40, -40";
          halign = "left";
          valign = "top";
        }
        {
          # battery, top right (empty on hosts without one)
          monitor = "${primary}";
          text = ''cmd[update:30000] bat=$(cat /sys/class/power_supply/BAT*/capacity 2>/dev/null | head -1); [ -n "$bat" ] && echo "$bat% 󰁹"'';
          color = "rgb(${c.base0B})";
          font_family = "JetBrainsMono Nerd Font Mono";
          font_size = 16;
          position = "-40, -40";
          halign = "right";
          valign = "top";
        }
        {
          # hours
          monitor = "${primary}";
          text = ''cmd[update:1000] date +"%H"'';
          color = "rgb(${c.base0D})";
          font_family = "JetBrainsMono Nerd Font Mono ExtraBold";
          font_size = 150;
          position = "0, 170";
          halign = "center";
          valign = "center";
        }
        {
          # minutes
          monitor = "${primary}";
          text = ''cmd[update:1000] date +"%M"'';
          color = "rgb(${c.base05})";
          font_family = "JetBrainsMono Nerd Font Mono ExtraBold";
          font_size = 150;
          position = "0, 10";
          halign = "center";
          valign = "center";
        }
        {
          # nix glyph on the accent chip
          monitor = "${primary}";
          text = "󱄅";
          color = "rgb(${c.base00})";
          font_family = "JetBrainsMono Nerd Font Mono";
          font_size = 34;
          position = "0, -172";
          halign = "center";
          valign = "center";
          zindex = 2;
        }
        {
          # user@host inside the glass card
          monitor = "${primary}";
          text = "${username}@${host}";
          color = "rgb(${c.base04})";
          font_family = "JetBrainsMono Nerd Font Mono Bold";
          font_size = 13;
          position = "0, -242";
          halign = "center";
          valign = "center";
        }
        {
          # now playing, bottom left (empty when nothing plays)
          monitor = "${primary}";
          text = ''cmd[update:2000] playerctl metadata --format '󰎇  {{artist}} - {{title}}' 2>/dev/null | cut -c1-90'';
          color = "${rgba "base05" "0.8"}";
          font_family = "JetBrainsMono Nerd Font Mono";
          font_size = 14;
          position = "40, 40";
          halign = "left";
          valign = "bottom";
        }
      ];

      # glass card behind chip + user + input
      shape = [
        {
          monitor = "${primary}";
          size = "360, 230";
          rounding = 20;
          color = rgba "base00" "0.55";
          border_size = 1;
          border_color = "rgba(255, 255, 255, 0.12)";
          position = "0, -235";
          halign = "center";
          valign = "center";
          zindex = 0;
        }
        {
          # accent chip behind the nix glyph (same motif as the launcher profile)
          monitor = "${primary}";
          size = "68, 68";
          rounding = -1;
          color = "rgb(${c.base0D})";
          position = "0, -172";
          halign = "center";
          valign = "center";
          zindex = 1;
        }
      ];

      input-field = [
        {
          monitor = "${primary}";
          size = "280, 44";
          rounding = 12;
          outline_thickness = 1;
          outer_color = "rgba(255, 255, 255, 0.15)";
          inner_color = rgba "base02" "0.6";
          font_color = "rgb(${c.base05})";
          check_color = "rgb(${c.base0C})";
          fail_color = "rgb(${c.base08})";
          fail_text = "<i>wrong ($ATTEMPTS)</i>";
          placeholder_text = "<i>password</i>";
          dots_center = true;
          dots_size = 0.25;
          fade_on_empty = false;
          shadow_passes = 1;
          position = "0, -300";
          halign = "center";
          valign = "center";
        }
      ];
    };
  };
}

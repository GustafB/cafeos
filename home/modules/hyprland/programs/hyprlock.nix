{
  username,
  ...
}:
let
  images = "/home/${username}/.config/cafeos-assets/images";
  primary = "DP-4";
  secondary = "DP-3";
in
{
  programs.hyprlock = {
    enable = true;
    settings = {
      general = {
        disable_loading_bar = true;
        grace = 5;
        hide_cursor = true;
        no_fade_in = false;
      };
      background = [
        {
          monitor = "${secondary}";
          path = "/tmp/screenlock_0.png";
          blur_passes = 3;
          blur_size = 8;
          new_optimizations = true;
        }
        {
          monitor = "${primary}";
          path = "/tmp/screenlock_1.png";
          blur_passes = 3;
          blur_size = 8;
          new_optimizations = true;
        }
      ];
      label = [
        {
          # time
          monitor = "${primary}";
          text = "cmd[update:1000] echo \"$(date +\"%H:%M\")\"";
          font_family = "JetBrainsMono Nerd Font Mono";
          font_size = "128";
          position = "0, 100";
          halign = "center";
          valign = "center";
        }
        {
          # date
          monitor = "${primary}";
          text = "cmd[update:1000] echo \"$(date +\"%A, %-d %B %Y\")\"";
          font_family = "JetBrainsMono Nerd Font Mono";
          font_size = "24";
          position = "0, 0";
          halign = "center";
          valign = "center";
        }
      ];
      image = [
        {
          monitor = "${primary}";
          path = "${images}/face.jpg";
          size = 150;
          border_size = 4;
          border_color = "rgb(0C96F9)";
          rounding = -1;
          position = "0, -250";
          halign = "center";
          valign = "center";
        }
      ];
      input-field = [
        {
          monitor = "${primary}";
          size = "300, 50";
          position = "0, -400";
          dots_center = true;
          fade_on_empty = false;
          font_color = "rgb(CFE6F4)";
          inner_color = "rgb(657DC2)";
          outer_color = "rgb(0D0E15)";
          outline_thickness = 2;
          placeholder_text = "...";
          shadow_passes = 2;
        }
      ];
    };
  };
}

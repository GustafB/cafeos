{
  inputs,
  pkgs,
  ...
}:
{
  programs.hyprlock = {
    enable = true;
    settings = {
      general = {
        disable_loading_bar = true;
        # grace = 10;
        hide_cursor = true;
        no_fade_in = false;
      };
      background = [
        {
          monitor = "DP-3";
          path = "/tmp/screenlock_0.png";
          blur_passes = 3;
          blur_size = 8;
          new_optimizations = true;
        }
        {
          monitor = "DP-4";
          path = "/tmp/screenlock_1.png";
          blur_passes = 3;
          blur_size = 8;
          new_optimizations = true;
        }
      ];
      image = [
        {
          path = "/home/cafebabe/cafeos/config/images/face.jpg";
          size = 150;
          border_size = 4;
          border_color = "rgb(0C96F9)";
          rounding = -1;
          position = "0, 200";
          halign = "center";
          valign = "center";
        }
      ];
      input-field = [
        {
          size = "200, 50";
          position = "0, -80";
          monitor = "";
          dots_center = true;
          fade_on_empty = false;
          font_color = "rgb(CFE6F4)";
          inner_color = "rgb(657DC2)";
          outer_color = "rgb(0D0E15)";
          outline_thickness = 2;
          placeholder_text = "'<span foreground=\"##cad3f5\">Password...</span>'";
          shadow_passes = 2;
        }
      ];
    };
  };

}

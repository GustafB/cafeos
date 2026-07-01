{
  pkgs,
  username,
  lib,
  vars,
  ...
}:
lib.mkIf vars.gui {
  services.greetd = {
    enable = true;
    settings = {
      initial_session = {
        user = username;
        command = "start-hyprland";
      };
      default_session = {
        user = username;
        command = "${pkgs.tuigreet}/bin/tuigreet --time --time-format '%I:%M %p | %a * %h | %F' --cmd start-hyprland";
      };
    };
  };
}

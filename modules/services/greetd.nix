{
  pkgs,
  username,
  ...
}:
{
  services.greetd = {
    enable = true;
    vt = 3;
    settings = {
      initial_session = {
        user = username;
        command = "Hyprland";
      };
      default_session = {
        user = username;
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --time-format '%I:%M %p | %a * %h | %F' --cmd Hyprland";
      };
    };
  };
}

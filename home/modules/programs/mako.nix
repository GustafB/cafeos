{
  ...
}:
{
  # Wayland notification daemon. Colours/fonts come from Stylix's mako target;
  # this just sets layout/behaviour. Runs as a systemd user service.
  services.mako = {
    enable = true;
    settings = {
      anchor = "top-right";
      default-timeout = 5000;
      border-radius = 12;
      border-size = 2;
      padding = "12";
      margin = "12";
      width = 340;
      height = 140;
      max-icon-size = 48;
    };
  };
}

{
  lib,
  config,
  ...
}:
{
  # Wayland notification daemon. Colours/fonts come from Stylix's mako target;
  # this sets layout/behaviour, plus a translucent background override for the
  # frosted-glass look (blur via hyprland layerrule on the mako namespace).
  services.mako = {
    enable = true;
    settings = {
      background-color = lib.mkForce "${config.lib.stylix.colors.withHashtag.base00}B3";
      anchor = "top-right";
      default-timeout = 5000;
      border-radius = 12;
      border-size = 2;
      padding = "12";
      margin = "12";
      width = 340;
      height = 140;
      max-icon-size = 48;

      # flipped by the dnd-toggle applet and the control center bell
      "mode=do-not-disturb" = {
        invisible = 1;
      };
    };
  };
}

{
  vars,
  ...
}:
{
  # night light: warms the screen after sunset, computed from the host
  # location in hosts/*/variables.nix (shared with the weather island)
  services.wlsunset = {
    enable = true;
    latitude = vars.latitude;
    longitude = vars.longitude;
    temperature = {
      day = 6500;
      night = 4000;
    };
  };
}

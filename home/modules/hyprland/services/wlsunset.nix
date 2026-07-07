{
  ...
}:
{
  # night light: warms the screen after sunset, computed from location
  services.wlsunset = {
    enable = true;
    # Stockholm-ish; close enough anywhere in Sweden for sunset times
    latitude = 59.3;
    longitude = 18.1;
    temperature = {
      day = 6500;
      night = 4000;
    };
  };
}

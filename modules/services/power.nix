{
  lib,
  vars,
  ...
}:
lib.mkIf vars.gui {
  # dbus-driven cpu/platform power profiles (balanced by default; switch with
  # `powerprofilesctl set power-saver|balanced|performance`)
  services.power-profiles-daemon.enable = true;
  services.upower.enable = true;
}

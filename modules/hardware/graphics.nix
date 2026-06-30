{
  lib,
  vars,
  ...
}:
lib.mkIf vars.gui {
  hardware.graphics = {
    enable = true;
    enable32Bit = false;
  };
}

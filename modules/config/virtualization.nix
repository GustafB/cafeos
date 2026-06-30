{
  pkgs,
  lib,
  vars,
  ...
}:
lib.mkIf vars.gui {
  virtualisation = {
    libvirtd.enable = true;
    podman = {
      enable = true;
      dockerCompat = true;
      defaultNetwork.settings.dns_enabled = true;
    };
  };

}

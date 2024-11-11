{
  pkgs,
  username,
  ...
}:
let
  inherit (import ./variables.nix) gitUsername;
in
{
  users.users = {
    "${username}" = {
      homeMode = "755";
      home = "/home/${username}";
      isNormalUser = true;
      description = "${gitUsername}";
      extraGroups = [
        "networkmanager"
        "wheel"
        "libvirtd"
        "docker"
      ];
      shell = pkgs.zsh;
      ignoreShellProgramCheck = true;
      packages = with pkgs; [ ];
    };
  };
}

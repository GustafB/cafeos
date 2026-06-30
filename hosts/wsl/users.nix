{
  pkgs,
  username,
  ...
}:
{
  # NixOS-WSL creates the default user (wsl.defaultUser); here we just set the
  # login shell and group membership for it.
  users.users."${username}" = {
    shell = pkgs.zsh;
    extraGroups = [ "wheel" ];
  };
}

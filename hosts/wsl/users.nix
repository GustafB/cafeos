{
  pkgs,
  username,
  ...
}:
{
  users.users."${username}" = {
    shell = pkgs.zsh;
    extraGroups = [ "wheel" ];
    linger = true;
  };
}

{
  programs = {
    _1password.enable = true;
    _1password-gui = {
      enable = true;
      polkitPolicyOwners = [ "{$username}" ];
    };

    ssh = {
      startAgent = true;
      extraConfig = ''
        Host *
        IdentityAgent ~/.1password/agent.sock
      '';
    };
  };
}

{
  services.openssh = {
    enable = true;
    startWhenNeeded = true;
    settings = {
      AllowAgentForwarding = true;
    };
  };
}

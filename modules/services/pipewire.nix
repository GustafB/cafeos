{
  services.pipewire = {
    enable = true;
    audio.enable = true; # enables pavucontrol
    alsa = {
      enable = true;
      support32Bit = true;
    };
    pulse.enable = true;
  };
}

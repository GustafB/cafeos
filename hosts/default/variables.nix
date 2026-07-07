{
    # feature toggles consumed across the module tree
    gui = true; # full desktop (hyprland, audio, graphics, fonts, ...)

    # location: drives the night-light schedule (wlsunset) AND the bar's
    # weather island -- single source, keep it here
    latitude = "59.3";
    longitude = "18.1";

    gitUsername = "gustafb";
    gitEmail = "gustaf.brostedt@gmail.com";
    gitPublicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEBqWi2Bxg6SQGP4OyfDwZsBLiOUUZGEzfnagxt3rh8i";
    keyboardLayout = "us";
    monitorSettings = "
monitor=DP-4, preferred, auto, 1
monitor=DP-3, 3460x2160, 3460x0, 1, transform, 1
";
    browser = "brave";
    terminal = "kitty";
}

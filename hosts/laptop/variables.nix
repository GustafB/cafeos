{
    # feature toggles consumed across the module tree
    gui = true; # full desktop (hyprland, audio, graphics, fonts, ...)

    # wallpaper (in home/modules/hyprland/config/assets/wallpapers/); also the
    # seed image Stylix derives the system palette from
    wallpaper = "stalenhag-nightcity.jpg";

    # location: drives the night-light schedule (wlsunset) AND the bar's
    # weather island -- single source, keep it here
    latitude = "59.3";
    longitude = "18.1";

    gitUsername = "gustafb";
    gitEmail = "gustaf.brostedt@gmail.com";
    gitPublicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEBqWi2Bxg6SQGP4OyfDwZsBLiOUUZGEzfnagxt3rh8i";
    keyboardLayout = "us";
    monitorSettings = "
monitor=eDP-1,2560x1600@60,0x0,1.25
    ";
    browser = "brave";
    terminal = "kitty";
}

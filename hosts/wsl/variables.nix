{
    # feature toggles consumed across the module tree
    gui = false; # headless WSL install: no hyprland, audio, graphics, fonts
    wsl = true; # WSL host: bridge 1Password's SSH agent from the Windows app

    # Windows account name; used to locate the Windows-side 1Password
    # op-ssh-sign-wsl.exe under /mnt/c/Users/<windowsUsername>/...
    windowsUsername = "gusta";

    gitUsername = "gustafb";
    gitEmail = "gustaf.brostedt@gmail.com";
    gitPublicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEBqWi2Bxg6SQGP4OyfDwZsBLiOUUZGEzfnagxt3rh8i";
    keyboardLayout = "us";
    monitorSettings = "";
    browser = "brave";
    terminal = "kitty";
}

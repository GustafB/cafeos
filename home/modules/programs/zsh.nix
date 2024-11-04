{ host, ... }:
{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    # load personal config and enable emacs keybinds for cmdline
    initExtra = ''
      fastfetch
      if [[ -f $HOME/.zshrc-personal ]]; then
      source $HOME/.zshrc-personal
      fi
      bindkey -e
      	  '';
    shellAliases = {
      sv = "sudo nvim";
      v = "nvim";
      cat = "bat";
      ls = "eza --icons";
      ll = "eza -lh --icons --grid --group-directories-first";
      la = "eza -lah --icons --grid --group-directories-first";
      ".." = "cd ..";
      "..2" = "cd ../..";
      "..3" = "cd ../../..";
      "..4" = "cd ../../../..";
      "wifi" = "nmtui";
      rebuild = "sudo nixos-rebuild switch --flake ~/cafeos/#${host}";
      poweroff = "sudo shutdown -h now";
    };
  };
}

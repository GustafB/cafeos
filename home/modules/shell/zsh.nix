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
      cat = "bat --color=always --theme=base16";

      ls = "eza --icons";
      la = "eza -lah --tree";
      ll = "eza -lh --git --icons --color=auto --group-directories-first -s extension";
      cp = "cp -iv";
      rm = "rm -iv";
      mv = "mv -iv";

      g = "git";
      ga = "git add";
      gall = "git add --all";
      gb = "git branch";
      gc = "git commit -v";
      gcm = "git commit --message";
      gds = "git diff --staged";
      gd = "git diff";
      gs = "git status";
      gp = "git push";

      untar = "tar -xvf";

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

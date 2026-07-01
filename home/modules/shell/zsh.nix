{
  host,
  vars,
  lib,
  ...
}:
{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    history = {
      size = 1000000;
      save = 1000000;
      ignoreDups = true;
      ignoreSpace = true;
      share = true;
    };

    shellAliases = {
      # editors
      v = "nvim";
      vi = "nvim";
      vim = "nvim";
      sv = "sudo nvim";

      # listing (eza)
      ls = "eza --icons --group-directories-first";
      ll = "eza --icons --group-directories-first -l --git";
      la = "eza --icons --group-directories-first -la";
      lal = "eza --icons --group-directories-first -la";
      cat = "bat --plain";

      # safer file ops
      rm = "rm -iv";
      cp = "cp -iv";
      mv = "mv -iv";

      # screen / dirs
      c = "clear";
      cl = "clear; ll";
      cla = "clear; la";
      d = "dirs -v";

      # navigation
      ".." = "cd ..";
      "..2" = "cd ../..";
      "..3" = "cd ../../..";
      "..4" = "cd ../../../..";
      "..5" = "cd ../../../../..";

      # grep -> ripgrep (interactive only; aliases don't affect scripts)
      grep = "rg --color=auto";

      # git
      g = "git";
      ga = "git add";
      gall = "git add --all";
      gu = "git add -u";
      gb = "git branch";
      gc = "git commit -m";
      gco = "git checkout";
      gsw = "git switch";
      gd = "git diff";
      gdw = "git diff --word-diff=color";
      gds = "git diff --word-diff=color --staged";
      gs = "git status";
      gp = "git push origin $(git rev-parse --abbrev-ref HEAD)";
      glog = "git log --oneline";
      grv = "git remote -v";

      # misc
      untar = "tar -xvf";
      act = "source ./.venv/bin/activate";
      win = "explorer.exe ."; # open current dir in Windows Explorer

      # nix
      rb = "sudo nixos-rebuild switch --flake ~/cafeos/#${host}";
      nx = "nix-shell --run zsh";
    }
    // lib.optionalAttrs (vars.wsl or false) {
      # WSL: route interactive ssh (and ssh-add) through Windows OpenSSH so
      # they use the 1Password agent, exactly like git's core.sshCommand.
      # Aliases only affect interactive shells, so scripts keep native Linux
      # ssh. Note: ssh.exe reads Windows-side ~/.ssh/{config,known_hosts}.
      ssh = "ssh.exe";
      "ssh-add" = "ssh-add.exe";
    };

    initContent = ''
      bindkey -e

      # machine-local / private extras (not managed by nix)
      [[ -f "$HOME/priv/saporo_env" ]] && source "$HOME/priv/saporo_env"
      [[ -f "$HOME/.zsh_local" ]] && source "$HOME/.zsh_local"

      # --- functions ---
      # git diff fuzzy picker
      gfd() {
        local preview='git diff --color=always -- {-1}'
        git diff --name-only -z "$@" | tr -d '\n' | tr '\0' '\n' | fzf -m --ansi --preview "$preview"
      }

      # saporo docker helpers
      dsql() { docker exec "$(docker ps -q -f name=psql)" psql -U postgres main -c "$1"; }
      isql() { docker exec -it "$(docker ps -q -f name=psql)" psql -U postgres main; }
      mg()   { docker exec -it "$(docker ps -q -f name=mg)" mgconsole --term-colors=true; }
    '';
  };
}

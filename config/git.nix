{ pkgs, lib, gitUsername, gitEmail }:

{
  enable = true;
  userName = gitUsername;
  userEmail = gitEmail;
  extraConfig = {
    gpg = {
      format = "ssh";
    };
    "gpg \"ssh\"" = {
      program = "${lib.getExe' pkgs._1password-gui "op-ssh-sign"}";
    };
    commit = {
      gpgsign = true;
    };
    user = {
      signingKey = builtins.readFile ../secrets/github.pub;
    };
  };
  aliases = {
    un = "reset HEAD~1 --mixed";
    am = "commit -a --amend";
    cm = "commit -m";
    s = "status";
    ds = "diff --staged";
    all = "add .";
    au = "add -u";
    one = "log --oneline";
    p = "!git push origin $(git rev-parse --abbrev-ref HEAD)";
  };
}

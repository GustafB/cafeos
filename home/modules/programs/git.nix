{
  pkgs,
  lib,
  host,
  ...
}:
let
  inherit (import ../../../hosts/${host}/variables.nix) gitUsername gitEmail gitPublicKey;
in
{

  home.packages = with pkgs; [
    lazygit
    gitflow
  ];

  programs.git = {
    enable = true;
    package = pkgs.gitAndTools.gitFull;

    userName = gitUsername;
    userEmail = gitEmail;

    delta = {
      enable = true;
      options.dark = true;
    };

    extraConfig = {
      push.default = "current";
      merge.stat = "true";
      core.whitespace = "fix,-indent-with-non-tab,trailing-space,cr-at-eol";
      repack.usedeltabaseoffset = "true";
      pull.ff = "only";
      rebase = {
        autoSquash = true;
        autoStash = true;
      };
      rerere = {
        enabled = true;
        autoStash = true;
      };
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
        signingKey = gitPublicKey;
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
  };

  programs.lazygit = {
    enable = true;
  };
}

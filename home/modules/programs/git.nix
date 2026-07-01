{
  pkgs,
  lib,
  vars,
  ...
}:
let
  inherit (vars) gitUsername gitEmail gitPublicKey;

  isWsl = vars.wsl or false;

  # SSH commit signing goes through 1Password's SSH agent.
  #   - GUI hosts: the Linux 1Password app provides op-ssh-sign, talking to
  #     ~/.1password/agent.sock (see modules/programs/1password.nix).
  #   - WSL: there is no Linux 1Password app. The desktop app runs on Windows;
  #     we sign via its WSL bridge binary and route SSH auth through Windows'
  #     ssh.exe using native WSL interop (no socket forwarding needed).
  opSshSign =
    if isWsl then
      "/mnt/c/Users/${vars.windowsUsername}/AppData/Local/Microsoft/WindowsApps/op-ssh-sign-wsl.exe"
    else
      lib.getExe' pkgs._1password-gui "op-ssh-sign";
in
{

  home.packages = with pkgs; [
    lazygit
    gitflow
  ];

  programs.delta = {
    enable = true;
    enableGitIntegration = true;
    options.dark = true;
  };

  programs.git = {
    enable = true;
    package = pkgs.gitFull;

    # Everything now lives under `settings`, which renders through
    # lib.generators.toGitINI just like the old `extraConfig` did — so nested
    # attrs (and subsections like `gpg "ssh"`) map straight onto gitconfig.
    settings = {
      user = {
        name = gitUsername;
        email = gitEmail;
        signingKey = gitPublicKey;
      };

      push.default = "current";
      merge.stat = "true";
      core = {
        whitespace = "fix,-indent-with-non-tab,trailing-space,cr-at-eol";
      }
      // lib.optionalAttrs isWsl {
        # Use the Windows OpenSSH client so SSH auth (push/pull, signing) is
        # served by the 1Password agent running in the Windows desktop app.
        sshCommand = "ssh.exe";
      };
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
      gpg.format = "ssh";
      "gpg \"ssh\"".program = opSshSign;
      commit.gpgsign = true;

      alias = {
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
  };

  programs.lazygit = {
    enable = true;
  };
}

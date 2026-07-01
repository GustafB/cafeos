{ pkgs, config, ... }:
{
  home.packages = with pkgs; [
    gofumpt
    goimports-reviser
    golangci-lint
    golines
    gomodifytags
    gotests
    go-tools
    go-tools
  ];

  programs.go = {
    enable = true;
    # goPath/goBin were renamed to env.GOPATH/env.GOBIN, which now take
    # absolute paths (the old options prepended $HOME implicitly).
    env = {
      GOPATH = "${config.home.homeDirectory}/.go";
      GOBIN = "${config.home.homeDirectory}/.local/bin";
    };
  };
}

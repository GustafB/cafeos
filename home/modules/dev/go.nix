{ pkgs, ... }:
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
    goPath = ".go";
    goBin = ".local/bin";
  };
}

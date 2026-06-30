{ pkgs, inputs, ... }:
{
  programs = {
    neovim = {
      enable = true;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;
      vimdiffAlias = true;
      withNodeJs = true;
      extraPackages = with pkgs; [
        # node provider (nodejs + neovim client) is supplied by withNodeJs

        # for telescope
        fd
        ripgrep

        # golang
        gopls
        go
        delve
        golangci-lint

        # nix
        nil
        statix
        nixfmt-rfc-style
        nixpkgs-fmt

        # lua
        lua-language-server
        stylua

        # C, C++
        clang-tools
        cppcheck

        # Shell
        shfmt
        shellcheck
        shellharden

        # python
        (python313.withPackages (
          ps: with ps; [
            setuptools
            black
            isort
            debugpy
            ruff
            pyright
            mypy
          ]
        ))

        # additional
        marksman
        xclip
        wl-clipboard
        codespell
        gitlint
        lazygit
      ];
    };
  };
}

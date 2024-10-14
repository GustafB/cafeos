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
        nodePackages.npm
        nodePackages.neovim
        
        # for telescope
        fd
        ripgrep


        # golang
        gopls
        go
        delve
        golangci-lint

        # nix
        statix
        nixpkgs-fmt

        # lua
        lua-language-server
        luajitPackages.lua-lsp
        stylua

        # C, C++
        clang-tools
        cppcheck

        # Shell
        shfmt
        shellcheck
        shellharden

        # python
        (python311.withPackages (ps: with ps; [
          setuptools
          black
          isort
          debugpy
          ruff
          pyright
        ]))

        # additional
        marksman
        xclip
        wl-clipboard
        codespell
        gitlint
      ];
    };
  };
}


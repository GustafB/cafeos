{
  pkgs,
  inputs,
  config,
  ...
}:
{
  # LazyVim config lives in the dotfiles clone and stays editable/writable
  # (LazyVim & Mason write lazy-lock.json / state in place). An out-of-store
  # symlink points at the live working copy rather than a frozen /nix/store
  # copy, so ~/dotfiles must be cloned for nvim to find its config.
  xdg.configFile."nvim".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/config/nvim";

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

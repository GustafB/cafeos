{
  pkgs,
  config,
  ...
}:
{
  # Neovim is installed as a plain package (NOT programs.neovim) so it reads
  # the standard ~/.config/nvim with no home-manager-generated init.lua. That
  # lets our LazyVim symlink fully own the config dir. LazyVim/lazy.nvim install
  # plugins and Mason installs LSPs at runtime (nix-ld makes those binaries run);
  # the tools below are a reliable Nix baseline on PATH.
  home.packages = with pkgs; [
    neovim
    nodejs # node provider + node-based LSPs/tools

    # telescope
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
    nixfmt

    # lua
    lua-language-server
    stylua

    # C, C++
    clang-tools
    cppcheck

    # shell
    shfmt
    shellcheck
    shellharden

    # python LSP/formatters are installed by LazyVim's python extra via Mason
    # (nix-ld makes them run). The python3 provider comes from dev/python313.nix
    # (which carries pynvim), so no second python env is added here.

    # additional
    marksman
    xclip
    wl-clipboard
    codespell
    gitlint
    lazygit
  ];

  home.sessionVariables.EDITOR = "nvim";

  # LazyVim config from the editable dotfiles clone (~/dotfiles must be cloned).
  # Out-of-store symlink keeps it editable/writable for lazy.nvim & Mason.
  xdg.configFile."nvim".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/config/nvim";
}

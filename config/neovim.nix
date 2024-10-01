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
        gopls
        xclip
        wl-clipboard
        lua-language-server
        luajitPackages.lua-lsp
        stylua
        nil
        rust-analyzer
        yaml-language-server
        pyright
        ruff
        marksman
        clang
        nixpkgs-fmt
      ];
    };
  };
}


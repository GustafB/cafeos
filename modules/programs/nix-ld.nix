{
  ...
}:
{
  # Runtime loader shim so unpatched, dynamically-linked prebuilt binaries run
  # on NixOS — e.g. LazyVim's Mason-installed LSPs/formatters and nvm's node.
  programs.nix-ld.enable = true;
}

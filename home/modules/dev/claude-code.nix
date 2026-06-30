{ pkgs, ... }:
{
  # Anthropic's agentic CLI. Shared (non-GUI) so it lands on every host,
  # including headless WSL. `claude-code` is unfree, covered by the host's
  # nixpkgs.config.allowUnfree.
  home.packages = with pkgs; [
    claude-code
  ];

  # The Nix store is read-only, so the built-in auto-updater can never write.
  # Disable it to avoid the start-up update nag (Nix owns the version instead).
  home.sessionVariables = {
    DISABLE_AUTOUPDATER = "1";
  };
}

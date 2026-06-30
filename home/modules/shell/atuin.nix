{
  ...
}:
{
  # SQLite-backed, fuzzy, context-aware shell history (replaces the old
  # zsh-fzf-history-search plugin). Ctrl-R opens atuin; Up stays plain zsh
  # history so it doesn't hijack arrow navigation.
  programs.atuin = {
    enable = true;
    enableZshIntegration = true;
    flags = [ "--disable-up-arrow" ];
    settings = {
      style = "compact";
      inline_height = 25;
      update_check = false;
    };
  };
}

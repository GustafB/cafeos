{
  pkgs,
  lib,
  vars,
  ...
}:
let
  # xdg-open ignores Terminal=true entries unless a terminal is registered
  # with gio, so wrap nvim in the terminal explicitly
  nvimDesktop = "nvim-term.desktop";

  textMimes = [
    "text/plain"
    "text/markdown"
    "text/csv"
    "text/x-c"
    "text/x-c++"
    "text/x-csrc"
    "text/x-chdr"
    "text/x-go"
    "text/x-java"
    "text/x-lua"
    "text/x-makefile"
    "text/x-python"
    "text/x-readme"
    "text/x-rust"
    "text/x-script.python"
    "text/x-shellscript"
    "text/x-tex"
    "application/json"
    "application/x-yaml"
    "application/toml"
    "application/xml"
    "application/x-shellscript"
  ];
  imageMimes = [
    "image/png"
    "image/jpeg"
    "image/gif"
    "image/webp"
    "image/bmp"
    "image/tiff"
    "image/avif"
    "image/svg+xml"
  ];
  videoMimes = [
    "video/mp4"
    "video/webm"
    "video/x-matroska"
    "video/x-msvideo"
    "video/quicktime"
    "video/mpeg"
  ];
  audioMimes = [
    "audio/mpeg"
    "audio/flac"
    "audio/ogg"
    "audio/x-wav"
    "audio/mp4"
  ];
  archiveMimes = [
    "application/zip"
    "application/gzip"
    "application/x-tar"
    "application/x-compressed-tar"
    "application/x-bzip2-compressed-tar"
    "application/x-7z-compressed"
    "application/vnd.rar"
    "application/zstd"
  ];

  assoc = mimes: app: lib.genAttrs mimes (_: app);
in
{
  home.packages = with pkgs; [
    imv # image viewer (vim keys)
    vlc
    xarchiver # backend for thunar-archive-plugin
  ];

  # vim-keyed pdf viewer; stylix recolors documents to the palette
  programs.zathura.enable = true;

  xdg.desktopEntries.nvim-term = {
    name = "Neovim";
    genericName = "Text Editor";
    exec = "${vars.terminal} -e nvim %F";
    icon = "nvim";
    categories = [ "Utility" "TextEditor" ];
    mimeType = textMimes;
  };

  xdg.mimeApps = {
    enable = true;
    defaultApplications =
      assoc textMimes nvimDesktop
      // assoc imageMimes "imv.desktop"
      // assoc videoMimes "vlc.desktop"
      // assoc audioMimes "vlc.desktop"
      // assoc archiveMimes "xarchiver.desktop"
      // {
        "application/pdf" = "org.pwmt.zathura.desktop";
        "inode/directory" = "thunar.desktop";
      };
  };
}

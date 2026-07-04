{ pkgs, config, ... }:
{
  imports = [
    ./scripts/rofi-launcher.nix
  ];

  # App icons for the drun grid (icon-theme below).
  home.packages = [ pkgs.papirus-icon-theme ];

  programs = {
    rofi = {
      enable = true;
      package = pkgs.rofi;
      extraConfig = {
        modi = "drun,run,filebrowser";
        show-icons = true;
        icon-theme = "Papirus-Dark";
        location = 0;
        font = "JetBrainsMono Nerd Font Mono 12";
        drun-display-format = "{name}";
        display-drun = "󰀻  Apps";
        display-run = "󰅴  Run";
        display-filebrowser = "󰉋  Files";
      };
    };
  };

  # App launcher theme, modeled on surface-dots' "wide" launcher: left
  # sidebar (search / modes / profile), right icon grid. Colours come from
  # the palette-generated shared.rasi (glass* vars, blur+dim via layerrule).
  xdg.configFile."rofi/themes/launcher.rasi".text = ''
    configuration {
        show-icons:                 true;
        drun-display-format:        "{name}";
        hover-select:               true;
        me-select-entry:            "";
        me-accept-entry:            "MousePrimary";
        sort:                       true;
        sorting-method:             "fzf";
        matching:                   "fuzzy";
        click-to-exit:              true;
    }

    @import "shared.rasi"

    window {
        transparency:       "real";
        location:           center;
        anchor:             center;
        width:              950px;
        height:             520px;
        border:             1px solid;
        border-color:       @glass-edge;
        border-radius:      16px;
        background-color:   @glass;
        cursor:             "default";
    }

    mainbox {
        spacing:            0px;
        background-color:   transparent;
        orientation:        horizontal;
        children:           [ "sidebar-box", "listbox" ];
    }

    /* ---- left sidebar: search / modes / profile ---- */
    sidebar-box {
        width:              260px;
        expand:             false;
        orientation:        vertical;
        spacing:            18px;
        padding:            24px;
        background-color:   transparent;
        children:           [ "inputbar", "mode-switcher", "sidebar-spacer", "user-profile" ];
    }

    inputbar {
        spacing:            0px;
        padding:            2px;
        border:             1px solid;
        border-color:       @glass-edge-dim;
        border-radius:      10px;
        background-color:   @glass-item;
        text-color:         @foreground;
        orientation:        horizontal;
        children:           [ "textbox-prompt-colon", "entry" ];
    }

    textbox-prompt-colon {
        expand:             false;
        str:                "󰍉";
        padding:            10px 4px 10px 14px;
        background-color:   transparent;
        text-color:         @selected;
        vertical-align:     0.5;
    }

    entry {
        expand:             true;
        padding:            10px 8px;
        background-color:   transparent;
        text-color:         inherit;
        cursor:             text;
        placeholder:        "Search";
        placeholder-color:  @foreground;
        vertical-align:     0.5;
    }

    mode-switcher {
        spacing:            10px;
        background-color:   transparent;
        text-color:         @foreground;
        orientation:        vertical;
    }

    button {
        padding:            12px 14px;
        border-radius:      10px;
        border:             1px solid;
        border-color:       @glass-edge-dim;
        background-color:   @glass-item;
        text-color:         inherit;
        cursor:             pointer;
        horizontal-align:   0.0;
    }

    button selected {
        background-image:   linear-gradient(to right, ${config.lib.stylix.colors.withHashtag.base0D}, ${config.lib.stylix.colors.withHashtag.base0C});
        border-color:       @selected;
        text-color:         @background;
    }

    sidebar-spacer {
        expand:             true;
        background-color:   transparent;
    }

    user-profile {
        orientation:        horizontal;
        expand:             false;
        spacing:            12px;
        background-color:   transparent;
        children:           [ "textbox-user-icon", "textbox-user" ];
    }

    textbox-user-icon {
        str:                "󱄅";
        expand:             false;
        padding:            10px 13px;
        border-radius:      10px;
        background-color:   @selected;
        text-color:         @background;
        vertical-align:     0.5;
        horizontal-align:   0.5;
    }

    textbox-user {
        str:                "${config.home.username}";
        expand:             true;
        background-color:   transparent;
        text-color:         @foreground;
        font:               "JetBrainsMono Nerd Font Bold 12";
        vertical-align:     0.5;
    }

    /* ---- right: app grid ---- */
    listbox {
        spacing:            0px;
        padding:            20px;
        background-color:   transparent;
        orientation:        vertical;
        children:           [ "listview" ];
        border:             0px 0px 0px 1px;
        border-color:       @glass-edge-dim;
    }

    listview {
        columns:            4;
        lines:              4;
        cycle:              true;
        dynamic:            true;
        scrollbar:          false;
        layout:             vertical;
        fixed-columns:      true;
        spacing:            10px;
        background-color:   transparent;
        text-color:         @foreground;
        cursor:             "default";
    }

    element {
        spacing:            10px;
        padding:            15px 8px;
        border-radius:      12px;
        border:             1px solid;
        border-color:       @glass-edge-dim;
        background-color:   @glass-item;
        text-color:         @foreground;
        cursor:             pointer;
        orientation:        vertical;
        children:           [ "element-icon", "element-text" ];
    }

    element selected.normal {
        background-image:   linear-gradient(to bottom, ${config.lib.stylix.colors.withHashtag.base0D}, ${config.lib.stylix.colors.withHashtag.base0C});
        border-color:       @selected;
        text-color:         @background;
    }

    element-icon {
        background-color:   transparent;
        text-color:         inherit;
        size:               48px;
        cursor:             inherit;
        horizontal-align:   0.5;
    }

    element-text {
        font:               "JetBrainsMono Nerd Font 10";
        background-color:   transparent;
        text-color:         inherit;
        cursor:             inherit;
        horizontal-align:   0.5;
        vertical-align:     0.5;
    }
  '';
}

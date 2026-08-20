{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: {
  imports = [inputs.noctalia.homeModules.default];

  programs.noctalia = {
    enable = true;
    # Niri starts Noctalia directly, as recommended by the upstream docs.
    systemd.enable = false;
    settings = {
      audio.enable_overdrive = true;
      backdrop.enabled = true;
      bar.default = {
        background_opacity = 0.88;
        start = ["control-center" "launcher" "workspaces"];
        center = ["clock"];
        end = [
          "lyrics"
          "tray"
          "icefish/phone-connect:bar"
          "notifications"
          "clipboard"
          "network"
          "volume"
          "brightness"
          "battery"
          "session"
        ];
      };
      brightness.enable_ddcutil = true;
      calendar.enabled = true;
      location.auto_locate = true;
      nightlight.enabled = true;
      osd.kinds.media = false;
      plugin_settings."h465855hgg/lyrics".player_allowlist = ["*"];
      plugins.enabled = ["h465855hgg/lyrics" "icefish/phone-connect"];
      widget.lyrics.type = "h465855hgg/lyrics:lyrics";
      shell = {
        polkit_agent = true;
        screen_time_enabled = true;
      };
      theme = {
        mode = "auto";
        source = "wallpaper";
        wallpaper_scheme = "m3-content";
        templates = {
          enable_builtin_templates = true;
          enable_community_templates = true;
          community_ids = ["zen-browser" "zed" "zellij"];
          builtin_ids = [
            "alacritty"
            "helix"
            "niri"
            "gtk3"
            "gtk4"
            "kcolorscheme"
            "qt"
          ];
        };
      };
      wallpaper = {
        enabled = true;
        directory = "${config.home.homeDirectory}/Pictures/Wallpapers";
        automation = {
          enabled = true;
          interval_seconds = 7200;
          order = "random";
          recursive = true;
        };
      };
    };
  };

  home.packages = with pkgs; [
    adw-gtk3
    ddcutil
    glib
    qt6Packages.qt6ct
  ];

  # Let Noctalia's generated theme files drive these declarative configs.
  home.sessionVariables.QT_QPA_PLATFORMTHEME = "qt6ct";
  xdg.configFile."qt6ct/qt6ct.conf".text = ''
    [Appearance]
    color_scheme_path = ${config.xdg.configHome}/qt6ct/colors/noctalia.conf
    custom_palette = false
    style = Fusion
  '';
  programs.alacritty.settings = {
    general.import = ["~/.config/alacritty/themes/noctalia.toml"];
    colors = lib.mkForce {};
  };
  programs.helix.settings.theme = lib.mkForce "noctalia";
}

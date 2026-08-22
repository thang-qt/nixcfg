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
    # A Niri-bound service keeps plugin helper processes in one cgroup and
    # stops them before the compositor removes its Wayland socket.
    systemd.enable = true;
    settings = {
      audio.enable_overdrive = true;
      backdrop.enabled = true;
      bar.default = {
        background_opacity = 0.88;
        start = ["control-center" "launcher" "workspaces" "lyrics"];
        center = ["clock"];
        end = [
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
    playerctl
    qt6Packages.qt6ct
  ];

  systemd.user.services = {
    noctalia = {
      Unit = {
        BindsTo = lib.mkForce ["niri.service"];
        PartOf = lib.mkForce ["niri.service"];
        After = lib.mkForce ["niri.service"];
      };
      Service.TimeoutStopSec = 5;
      Install.WantedBy = lib.mkForce ["niri.service"];
    };

    kdeconnect = {
      Unit = {
        Description = "KDE Connect for the Niri session";
        BindsTo = ["niri.service"];
        PartOf = ["niri.service"];
        After = ["niri.service"];
      };
      Service = {
        ExecStart = "/run/current-system/sw/bin/kdeconnectd";
        Restart = "on-failure";
        RestartPreventExitStatus = 255;
        RestartSec = 2;
      };
      Install.WantedBy = ["niri.service"];
    };
  };

  # Plasma retains its normal autostart; Niri uses the ordered service above.
  xdg.configFile."autostart/org.kde.kdeconnect.daemon.desktop".text = ''
    [Desktop Entry]
    Type=Application
    Name=KDE Connect
    Exec=/run/current-system/sw/bin/kdeconnectd
    StartupNotify=false
    NoDisplay=true
    OnlyShowIn=KDE;
  '';

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

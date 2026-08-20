{
  inputs,
  config,
  lib,
  pkgs,
  ...
}: {
  nixpkgs.overlays = [
    inputs.self.overlays.llm-agents
  ];

  imports = [
    inputs.spicetify-nix.homeManagerModules.default
    inputs.sops-nix.homeManagerModules.sops
    ../common.nix
    inputs.self.homeManagerModules.pi
    inputs.self.homeManagerModules.firefox
    inputs.self.homeManagerModules.zen
    inputs.self.homeManagerModules.alacritty
    inputs.self.homeManagerModules.zellij
    inputs.self.homeManagerModules.spicetify
    inputs.self.homeManagerModules.mpv
    inputs.self.homeManagerModules.rescrobbled
    inputs.self.homeManagerModules.trakt-scrobbler
    inputs.self.homeManagerModules.niri
    inputs.noctalia.homeModules.default
    inputs.self.homeManagerModules.zathura
    inputs.self.homeManagerModules.yazi
    inputs.self.homeManagerModules.zed
    ../pi.nix
  ];

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
      plugins.enabled = ["h465855hgg/lyrics"];
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

  sops.age = {
    keyFile = "${config.home.homeDirectory}/.config/sops/age/keys.txt";
    sshKeyPaths = [];
  };

  home.packages = with pkgs; [
    adw-gtk3
    alacritty
    ddcutil
    python3
    qt6Packages.qt6ct
    thunderbird
    vacuum-tube
    gh
    llm-agents.codex
    llm-agents.antigravity-cli
    inputs.helium.packages.${pkgs.stdenv.hostPlatform.system}.helium
    hubstaff
    qbittorrent
    cider
    obsidian
    vscode
    koreader
  ];

  programs.git = {
    lfs.enable = true;
    settings.push.autoSetupRemote = true;
  };

  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    settings."*" = {
      IdentityAgent = "~/.1password/agent.sock";
    };
  };
}

{
  config,
  pkgs,
  ...
}:

{
  nixpkgs.config.allowUnfreePredicate = (_: true);

  home.username = "thang";
  home.homeDirectory = "/home/thang";
  xdg.enable = true;
  home.packages = with pkgs; [
    kde-rounded-corners
    obs-studio
    kdePackages.karousel
    python312Packages.kde-material-you-colors
    uv
    prismlauncher
    lazygit
    anki
    goldendict-ng
    qbittorrent
    obsidian
    masterpdfeditor4
    ungoogled-chromium
    rclone
    swww
    batsignal
    cliphist
    wl-clipboard
    imv
    xfce.thunar
    calibre
    tor-browser
    zed-editor
  ];

  services.kdeconnect.enable = true;

  home.sessionVariables = {
    EDITOR = "hx";
    VISUAL = "hx";
  };

  home.stateVersion = "24.11";

  imports = [
    ../../modules/home/git.nix
    ../../modules/home/fish.nix
    ../../modules/home/helix.nix
    ../../modules/home/kitty.nix
    ../../modules/home/zellij/base.nix
    ../../modules/home/wezterm.nix
    ../../modules/home/firefox.nix
    ../../modules/home/spicetify.nix
    ../../modules/home/mpv.nix
    ../../modules/home/gtk.nix
    ../../modules/home/prefer-dark.nix
    ../../modules/home/niri/base.nix
    ../../modules/home/waybar/base.nix
    ../../modules/home/rofi/base.nix
    ../../modules/home/swaync/base.nix
    ../../modules/home/zathura/base.nix
  ];

  programs.vscode = {
    enable = true;
    package = pkgs.vscode.fhs;
  };
}

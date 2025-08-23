{ config, pkgs, ... }:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.systemd-boot.configurationLimit = 5;
  boot.loader.systemd-boot.edk2-uefi-shell.enable = true;
  boot.loader.systemd-boot.windows."11".efiDeviceHandle = "HD0b";

  boot = {
    plymouth = {
      enable = true;
      theme = "hexagon_dots";
      themePackages = with pkgs; [
        (adi1090x-plymouth-themes.override {
          selected_themes = [ "hexagon_dots" ];
        })
      ];
    };

    # Enable "Silent boot"
    consoleLogLevel = 3;
    initrd.verbose = false;
    kernelParams = [
      "quiet"
      "splash"
      "boot.shell_on_fail"
      "udev.log_priority=3"
      "rd.systemd.show_status=auto"
    ];
    loader.timeout = 3;
  };

  networking.hostName = "leaf";

  networking.firewall = rec {
    allowedTCPPortRanges = [
      {
        from = 1714;
        to = 1764;
      }
    ]; # KDE Connect
    allowedUDPPortRanges = allowedTCPPortRanges;
  };

  # time.hardwareClockInLocalTime = true;

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
  };
  services.desktopManager.plasma6.enable = true;
  environment.plasma6.excludePackages = with pkgs; [
    xterm
    kdePackages.elisa
    kdePackages.plasma-browser-integration
    kdePackages.discover
  ];

  security.polkit.enable = true;

  users.users.thang = {
    shell = pkgs.fish;
    extraGroups = [
      "adbusers"
      "docker"
    ];
  };

  # Install firefox.
  programs.firefox.enable = true;

  environment.systemPackages = with pkgs; [
    home-manager
    helix
    git
    wget
    zoxide
    nix-your-shell
    spotify
    fastfetch
    thunderbird
    btop
    mpv
    zathura
    fzf
    fd
    ffmpeg
    yt-dlp
    stremio
    wineWowPackages.stable
    lutris
    onlyoffice-bin
  ];

  hardware.graphics.enable32Bit = true;

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
    localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
  };

  programs.fish.enable = true;

  programs.direnv = {
    enable = true;
    silent = true;
  };

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  programs.niri.enable = true;

  programs.nh.enable = true;

  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  services.tailscale.enable = true;

  services.flatpak.enable = true;
  systemd.services.flatpak-repo = {
    wantedBy = [ "multi-user.target" ];
    path = [ pkgs.flatpak ];
    script = ''
      flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
    '';
  };

  services.postgresql = {
    enable = true;
    package = pkgs.postgresql_15;
    enableTCPIP = true;
    port = 5432;
    authentication = pkgs.lib.mkOverride 10 ''
      local all all trust
      host all all 127.0.0.1/32 trust
      host all all ::1/128 trust
    '';
    initialScript = pkgs.writeText "backend-initScript" ''
      CREATE ROLE postgres WITH LOGIN PASSWORD 'postgres' CREATEDB SUPERUSER;
      CREATE DATABASE flashmind OWNER postgres;
    '';
  };

  programs.adb.enable = true;

  virtualisation.docker.rootless = {
    enable = true;
    setSocketVariable = true;
  };

  virtualisation.docker.rootless.daemon.settings = {
    dns = [
      "1.1.1.1"
      "8.8.8.8"
    ];
  };

  system.stateVersion = "24.11";
}

{
  inputs,
  lib,
  config,
  pkgs,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
    inputs.self.nixosModules.common
    inputs.self.nixosModules.bluetooth
    inputs.self.nixosModules.koito
    inputs.self.nixosModules.restic
    inputs.self.nixosModules.gaming
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.initrd.luks.devices."luks-f63d4774-dcc7-4f57-b085-7ad9cd683c57".device =
    "/dev/disk/by-uuid/f63d4774-dcc7-4f57-b085-7ad9cd683c57";

  networking.hostName = "pathway";
  networking.networkmanager.enable = true;

  services.xserver.enable = true;
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
  };
  services.desktopManager.plasma6.enable = true;
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5.addons = with pkgs; [
      fcitx5-gtk
      libsForQt5.fcitx5-qt
      qt6Packages.fcitx5-configtool
      fcitx5-bamboo
    ];
  };

  services.printing.enable = true;

  services.power-profiles-daemon.enable = true;
  services.upower.enable = true;

  services.pulseaudio.enable = false;

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  programs.niri.enable = true;

  # services.cloudflare-warp.enable = true;

  programs.firefox.enable = true;
  programs._1password.enable = true;
  programs._1password-gui = {
    enable = true;
    polkitPolicyOwners = [ "thang" ];
  };
  programs.kdeconnect.enable = true;

  virtualisation.docker = {
    enable = true;
    daemon.settings = {
      dns = [
        "1.1.1.1"
        "8.8.8.8"
      ];
    };
    rootless = {
      enable = true;
      setSocketVariable = true;
      daemon.settings = {
        dns = [
          "1.1.1.1"
          "8.8.8.8"
        ];
      };
    };
  };

  users.users.thang = {
    extraGroups = lib.mkAfter [
      "networkmanager"
      "docker"
    ];
  };

  environment.systemPackages = with pkgs; [
    rclone
    qalculate-qt
    sops
    age
    libreoffice-qt
    hunspell
    kdePackages.sddm-kcm
    aria2
  ];

  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [
      corefonts
      liberation_ttf
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-color-emoji
      nerd-fonts.meslo-lg
      nerd-fonts.iosevka
    ];
  };

  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  system.stateVersion = "25.11";
}

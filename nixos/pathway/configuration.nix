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
    inputs.self.nixosModules.auto-cpufreq
    inputs.self.nixosModules.koito
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.initrd.luks.devices."luks-f63d4774-dcc7-4f57-b085-7ad9cd683c57".device =
    "/dev/disk/by-uuid/f63d4774-dcc7-4f57-b085-7ad9cd683c57";

  networking.hostName = "pathway";
  networking.networkmanager.enable = true;

  services.xserver.enable = true;
  services.displayManager.sddm.enable = true;
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

  services.power-profiles-daemon.enable = false;

  services.pulseaudio.enable = false;

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  services.cloudflare-warp.enable = true;

  programs.firefox.enable = true;
  programs._1password.enable = true;
  programs._1password-gui = {
    enable = true;
    polkitPolicyOwners = [ "thang" ];
  };
  programs.kdeconnect.enable = true;

  users.users.thang = {
    packages = with pkgs; [
      kdePackages.kate
    ];
    extraGroups = lib.mkAfter [ "networkmanager" ];
  };

  environment.systemPackages = with pkgs; [
    rclone
    qalculate-qt
    sops
    age
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
    ];
  };

  system.stateVersion = "25.11";
}

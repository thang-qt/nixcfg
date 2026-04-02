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
    ./data-binds.nix
    inputs.self.nixosModules.common
    inputs.self.nixosModules.bluetooth
    inputs.self.nixosModules.koito
    inputs.self.nixosModules.restic
    inputs.self.nixosModules.gaming
    inputs.self.nixosModules.docker
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.initrd.luks.devices."luks-f37aceda-6d5d-4c90-9baa-eb64220a6042".device =
    "/dev/disk/by-uuid/f37aceda-6d5d-4c90-9baa-eb64220a6042";
  boot.resumeDevice = "/dev/mapper/luks-f37aceda-6d5d-4c90-9baa-eb64220a6042";

  boot.initrd.secrets = {
    "/crypto_keyfile_data" = "/etc/luks-keys/data.key";
  };

  boot.initrd.luks.devices."data" = {
    device = "/dev/disk/by-uuid/e781ccf6-f534-48a5-be50-593106ca3eeb";
    keyFile = "/crypto_keyfile_data";
  };

  fileSystems."/data" = {
    device = "/dev/disk/by-uuid/40e0c532-375f-4842-a9ad-ad54dc5fb8b5";
    fsType = "btrfs";
    options = [
      "subvol=@data"
      "compress=zstd"
      "noatime"
    ];
  };

  networking.hostName = "pathway";
  networking.networkmanager.enable = true;

  services.xserver.enable = true;
  services.displayManager.sddm = {
    enable = true;
    wayland = {
      enable = true;
      compositor = "kwin";
    };
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

  programs.nix-ld = {
    enable = true;
  };

  users.users.thang = {
    extraGroups = lib.mkAfter [
      "networkmanager"
    ];
  };

  environment.systemPackages = with pkgs; [
    unrar
    kdePackages.sddm-kcm
    rclone
    qalculate-qt
    sops
    age
    onlyoffice-desktopeditors
    xwayland-satellite
    steam-run
    uv
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

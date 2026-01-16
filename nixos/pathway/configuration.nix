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
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.initrd.luks.devices."luks-f63d4774-dcc7-4f57-b085-7ad9cd683c57".device = "/dev/disk/by-uuid/f63d4774-dcc7-4f57-b085-7ad9cd683c57";

  networking.hostName = "pathway";
  networking.networkmanager.enable = true;

  services.xserver.enable = true;
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  services.printing.enable = true;

  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  programs.firefox.enable = true;

  users.users.thang = {
    packages = with pkgs; [
      kdePackages.kate
    ];
    extraGroups = lib.mkAfter [ "networkmanager" ];
  };

  system.stateVersion = "25.11";
}

{ config, pkgs, ... }:
{
  imports = [ ./hardware-configuration.nix ];

  networking.hostName = "matrix";

  # Desktop Environment.
  services.xserver = {
    enable = true;

    displayManager.gdm = {
      enable = true;
      wayland = true;
    };

    excludePackages = with pkgs; [ xterm ];

  };
  services.displayManager.defaultSession = "hyprland";

  # XDG Portal
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  # Polkit
  security.polkit.enable = true;
  services.gnome.gnome-keyring.enable = true;

  # Ignore power button
  services.logind.extraConfig = ''
    # don’t shutdown when power button is short-pressed
    HandlePowerKey=ignore
  '';

  # Default shell
  users.users.thang = {
    shell = pkgs.fish;
  };

  system.stateVersion = "23.11";

  # Fish
  programs.fish.enable = true;

  # Hyprland
  programs.hyprland = {
    enable = true;
    package = pkgs.unstable.hyprland;
    xwayland.enable = true;
  };

  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  programs.thunar = {
    enable = true;
    plugins = with pkgs.xfce; [
      thunar-archive-plugin
      thunar-volman
    ];
  };

  programs.file-roller.enable = true;
  programs.steam.enable = true;
  programs.adb.enable = true;
  services.tailscale.enable = true;
  services.flatpak.enable = true;

  programs.fuse.userAllowOther = true;
  systemd.services.onr2-mount = {
    enable = true;
    description = "Mount Rclone Remote";
    wants = [ "network-online.target" ];
    after = [ "network-online.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.rclone}/bin/rclone mount onr2:onthithpt /home/thang/onr2 --config /home/thang/.config/rclone/rclone.conf --allow-other --dir-cache-time 1h --vfs-cache-mode full";
      ExecStop = "${pkgs.coreutils}/bin/fusermount -u /home/thang/onr2";
      Restart = "on-failure";
    };
    wantedBy = [ "multi-user.target" ];
  };
}

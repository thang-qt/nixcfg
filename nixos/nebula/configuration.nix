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
    inputs.self.nixosModules.nginx
    inputs.self.nixosModules.open-webui
    inputs.self.nixosModules.readn
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelParams = [ "net.ifnames=0" ];

  networking.hostName = "nebula";

  # Users
  users.users = {
    thang = {
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAEEmpz4BTIDrPitcRgoE/rKdJXh/w4dH8n/gYBvZFUA"
      ];

    };
  };

  # Shells & programs
  environment.shells = [ pkgs.fish ];
  programs.fish.enable = true;

  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = false;
    };
  };

  system.stateVersion = "25.05";
}

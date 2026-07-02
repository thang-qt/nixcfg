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
    # inputs.self.nixosModules.open-webui
    inputs.self.nixosModules.readn
    inputs.self.nixosModules.koito
    inputs.self.nixosModules.docker
    inputs.kairos.nixosModules.default
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelParams = [ "net.ifnames=0" ];

  networking.hostName = "nebula";

  users.users = {
    thang = {
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAEEmpz4BTIDrPitcRgoE/rKdJXh/w4dH8n/gYBvZFUA"
      ];
      linger = true;
    };
  };

  environment.shells = [ pkgs.fish ];
  programs.fish.enable = true;

  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = false;
    };
  };

  custom_modules.koito = {
    enable = true;
    allowedHosts = "*";
  };

  services.kairos = {
    enable = true;
    port = 3457;
    listenAddress = "127.0.0.1";
    environment = {
      ADMIN_PASSWORD = "thang123";
    };
    settings = {
      appEnv = "production";
      cookieSecure = true;
      authEnabled = true;
      allowSignup = false;
      bootstrapAdmin = true;
      adminEmail = "thang@thangqt.com";
    };
  };

  system.stateVersion = "25.05";
}

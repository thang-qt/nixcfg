{
  config,
  inputs,
  pkgs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    inputs.self.nixosModules.common
    inputs.self.nixosModules.docker
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 10;
  boot.loader.efi.canTouchEfiVariables = false;

  boot.kernelParams = [
    "console=tty1"
    "console=ttyAMA0,115200n8"
  ];

  networking.hostName = "petri";
  networking.useDHCP = false;
  networking.interfaces.enp0s6.useDHCP = true;
  networking.firewall.trustedInterfaces = ["tailscale0"];
  networking.firewall.allowedTCPPorts = [2211];

  services.openssh = {
    enable = true;
    ports = [2211];
    openFirewall = true;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
    };
  };

  users.users.thang = {
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAEEmpz4BTIDrPitcRgoE/rKdJXh/w4dH8n/gYBvZFUA"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHZ7KokkDS4XU9M15R3htHbt4ZJ9NQeYxVbKWinbE3n5"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAkyDdWAGpKeCyQmuu/s+n2Di4zbH2hsBo0m8SKhD3z7 quangthang@ctrl-c.club"
    ];
  };

  security.sudo.wheelNeedsPassword = false;

  systemd.tmpfiles.rules = [
    "z /home/thang/.config/code-server/config.yaml 0600 thang users -"
  ];

  sops.secrets.code-server-password-hash = {
    sopsFile = ../../secrets/code-server.yaml;
    format = "yaml";
    key = "code_server_password_hash";
    mode = "0400";
    owner = "root";
    restartUnits = ["code-server.service"];
  };

  sops.templates."code-server-env" = {
    content = ''
      HASHED_PASSWORD=${config.sops.placeholder.code-server-password-hash}
    '';
    mode = "0400";
    owner = "root";
  };

  services.code-server = {
    enable = true;
    user = "thang";
    group = "users";
    host = "127.0.0.1";
    port = 4444;
    auth = "password";
    disableTelemetry = true;
    disableUpdateCheck = true;
  };

  systemd.services.code-server.serviceConfig.EnvironmentFile =
    config.sops.templates."code-server-env".path;

  sops.secrets.cloudflare-tunnel-credentials = {
    sopsFile = ../../secrets/cloudflared-credentials.json;
    format = "json";
    key = "";
    mode = "0400";
    owner = "root";
    restartUnits = ["cloudflared-tunnel-7b92ff59-1e66-4103-8ade-ca6d2117c1b5.service"];
  };

  services.cloudflared = {
    enable = true;

    tunnels."7b92ff59-1e66-4103-8ade-ca6d2117c1b5" = {
      credentialsFile = config.sops.secrets.cloudflare-tunnel-credentials.path;
      ingress."petri-code.thangqt.com" = {
        service = "http://127.0.0.1:4444";
      };
      default = "http_status:404";
    };
  };

  environment.systemPackages = with pkgs; [
    himalaya
    htop
    sops
    age
  ];

  system.stateVersion = "26.05";
}

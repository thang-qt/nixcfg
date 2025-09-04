{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
    ../../modules/services/glance.nix
    ../../modules/services/openwebui.nix
    (import ../../modules/agenix.nix { hostName = "satellite"; })
    inputs.readn.nixosModules.readn
  ];

  boot.loader.grub.device = "/dev/sda";

  system = {
    stateVersion = "24.11";
  };

  boot.tmp.cleanOnBoot = true;

  networking = {
    hostName = "satellite";
    firewall = rec {
      enable = true;
      allowedTCPPorts = [
        2222
        80
        443
        51820
      ];
      allowedUDPPorts = allowedTCPPorts;
    };
  };

  services = {
    openssh = {
      enable = true;
      ports = [ 2222 ];
      settings = {
        PasswordAuthentication = false;
        KbdInteractiveAuthentication = false;
        UseDns = true;
        X11Forwarding = false;
        PermitRootLogin = "prohibit-password";
      };
    };

    tailscale = {
      enable = true;
    };

    caddy = {
      enable = true;
      user = "www-data";
      group = "www-data";
      virtualHosts = {
        "llm.thangqt.com".extraConfig = ''
          tls internal
          reverse_proxy http://127.0.0.1:2855
        '';
        "glance.thangqt.com".extraConfig = ''
          tls internal
          reverse_proxy http://127.0.0.1:9943
        '';
        "read.thangqt.com".extraConfig = ''
          tls internal
          reverse_proxy http://127.0.0.1:7070
        '';
      };
    };

    # ReadN service
    readn = {
      enable = true;
      # Listen only on loopback; exposed via Caddy
      address = "127.0.0.1:7070";
      authFile = config.age.secrets.readn_auth.path;
    };
  };

  security.acme = {
    defaults.email = "thang@thang.com";
    acceptTerms = true;
  };

  users = {
    users = {
      "thang" = {
        shell = pkgs.fish;
        openssh.authorizedKeys.keys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHZ7KokkDS4XU9M15R3htHbt4ZJ9NQeYxVbKWinbE3n5"
        ];
        extraGroups = [ "podman" ];
      };
      # Dedicated service user for ReadN
      "readn" = {
        isSystemUser = true;
        group = "readn";
        home = "/var/lib/readn";
      };
      "www-data" = {
        isSystemUser = true;
        createHome = true;
        home = "/var/www";
        group = "www-data";
      };
    };
    groups."www-data" = { };
    groups."readn" = { };
  };

  environment = {
    systemPackages = with pkgs; [
      helix
    ];
  };

  programs.fish.enable = true;

  systemd.services.readn.serviceConfig = {
    User = "readn";
    Group = "readn";
    DynamicUser = lib.mkForce false;
  };
}

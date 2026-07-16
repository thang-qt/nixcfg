{
  inputs,
  lib,
  config,
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
    "f /var/lib/hermes/env 0600 hermes hermes - -"
    "f /var/lib/hermes/.hermes/.hermes_history 0660 hermes hermes - -"
  ];

  services.hermes-agent = {
    enable = true;
    package = inputs.hermes-agent.packages.${pkgs.system}.minimal;
    addToSystemPackages = true;
    environmentFiles = ["/var/lib/hermes/env"];
    environment = {
      API_SERVER_ENABLED = "true";
      API_SERVER_HOST = "0.0.0.0";
      API_SERVER_PORT = "8642";
    };
    workingDirectory = "/var/lib/hermes/workspace";

    settings = {
      # Provider/model are configured by `hermes setup`; preserve them here.
      toolsets = ["all"];
      max_turns = 100;
      terminal = {
        backend = "local";
        cwd = "/data/workspace";
        timeout = 180;
      };
      memory = {
        memory_enabled = true;
        user_profile_enabled = true;
      };
    };

    container = {
      enable = true;
      hostUsers = ["thang"];
      extraVolumes = [
        "/home/thang/Dev:/Dev:rw"
      ];
    };

    extraPackages = with pkgs; [
      curl
      fd
      git
      jq
      nodejs_22
      python3
      ripgrep
      uv
    ];
  };

  environment.systemPackages = with pkgs; [
    htop
    sops
    age
  ];

  system.stateVersion = "26.05";
}

{
  config,
  pkgs,
  lib,
  ...
}:

{
  networking.firewall.allowedTCPPorts = [
    80
    443
  ];

  services.nginx = {
    enable = true;

    # Sensible defaults from the NixOS module
    recommendedProxySettings = true;
    recommendedTlsSettings = true;
    recommendedGzipSettings = true;

    virtualHosts."llm.thangqt.com" = {
      # Automatic Let's Encrypt
      enableACME = true;
      forceSSL = true;

      locations."/" = {
        proxyPass = "http://127.0.0.1:3434";
        proxyWebsockets = true; # if your app uses websockets

        extraConfig = ''
          # In case the upstream ever speaks TLS / uses name-based vhosts
          proxy_ssl_server_name on;

          # Forward auth headers if your upstream needs them
          proxy_pass_header Authorization;
        '';
      };
    };
    virtualHosts."readn.thangqt.com" = {
      # Automatic Let's Encrypt
      enableACME = true;
      forceSSL = true;

      locations."/" = {
        proxyPass = "http://127.0.0.1:7070";

        extraConfig = ''
          proxy_ssl_server_name on;
          proxy_pass_header Authorization;
        '';
      };
    };

    virtualHosts."koito.thangqt.com" = {
      enableACME = true;
      forceSSL = true;

      locations."/" = {
        proxyPass = "http://127.0.0.1:4110";

        extraConfig = ''
          proxy_ssl_server_name on;
          proxy_pass_header Authorization;
        '';
      };
    };
  };

  security.acme = {
    acceptTerms = true;
    defaults.email = "thang@thangqt.com";
  };

  # Optional but nice if you're reusing ACME certs elsewhere
  users.users.nginx.extraGroups = [ "acme" ];
}

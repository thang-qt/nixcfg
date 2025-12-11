{
  config,
  lib,
  pkgs,
  ...
}:

{
  sops.secrets.readn-auth = {
    sopsFile = ../../secrets/readn.yaml;
    format = "yaml";
    key = "readn_auth";
    mode = "0400";
    owner = config.systemd.services.yarr.serviceConfig.User or "root";
    restartUnits = [ "yarr.service" ];
  };

  services.yarr = {
    enable = true;
    package = pkgs.yarr;
    port = 7070;
    address = "127.0.0.1";
    authFilePath = config.sops.secrets.readn-auth.path;
  };
}

{inputs, ...}: {
  imports = [inputs.threadline.nixosModules.default];

  services.threadline = {
    enable = true;
    address = "127.0.0.1:3366";
  };

  services.nginx.virtualHosts."threadline.thangqt.com" = {
    enableACME = true;
    forceSSL = true;
    locations."/".proxyPass = "http://127.0.0.1:3366";
  };
}

{config, ...}: {
  sops.secrets.kairos-env = {
    sopsFile = ../../secrets/nebula/kairos.yaml;
    format = "yaml";
    key = "environment";
    owner = "root";
    mode = "0400";
    restartUnits = ["kairos.service"];
  };

  services.kairos.environmentFile = config.sops.secrets.kairos-env.path;
}

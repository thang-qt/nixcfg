{
  config,
  pkgs,
  lib,
  ...
}:
{
  virtualisation.docker = {
    enable = false;
    rootless = {
      enable = true;
      setSocketVariable = true;
      daemon.settings = {
        dns = [
          "1.1.1.1"
          "8.8.8.8"
        ];
      };
    };
  };

  users.users.thang.linger = true;
}

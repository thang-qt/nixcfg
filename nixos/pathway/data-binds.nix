{ lib, ... }:

let
  bindDirs = [
    "Documents"
    "Dev"
    "Games"
    "Music"
    "Pictures"
    "Videos"
  ];

  mkBindMount = dir: {
    device = "/data/thang/${dir}";
    fsType = "none";
    options = [ "bind" ];
    depends = [ "/data" ];
  };
in
{
  fileSystems = lib.genAttrs
    (map (dir: "/home/thang/${dir}") bindDirs)
    (mountPoint:
      let
        dir = lib.last (lib.splitString "/" mountPoint);
      in
      mkBindMount dir);

  systemd.tmpfiles.rules = map (dir: "d /home/thang/${dir} 0755 thang users - -") bindDirs;
}

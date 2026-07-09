{ config, pkgs, ... }:
{
  home.packages = [ pkgs.trakt-scrobbler ];

  xdg.configFile."trakt-scrobbler/config.yaml".text = ''
    version: '1.0'
    general:
      enable_notifs: no
    players:
      monitored:
        - mpv
      mpv:
        # mpv/umpv uses this per-user IPC socket for the desktop-launched singleton instance.
        ipc_path: /run/user/1000/.umpv
    fileinfo:
      whitelist:
        - ${config.home.homeDirectory}/Videos
      include_regexes:
        episode:
          # Fixes pack folders like "Modern Family (2009) Season 1-11 S01-S11 .../Season 3/... S03E24 ..."
          - '.*/(?P<title>[^/]+?) \(\d{4}\).*?/Season (?P<season>\d+).*?/.*?S\d+E(?P<episode>\d+).*'
  '';

  systemd.user.services.trakt-scrobbler = {
    Unit = {
      Description = "Trakt Scrobbler Service";
      Documentation = "https://github.com/iamkroot/trakt-scrobbler";
      After = [ "graphical-session.target" ];
      PartOf = [ "graphical-session.target" ];
    };

    Service = {
      ExecStart = "${pkgs.trakt-scrobbler}/bin/trakts run";
      Restart = "on-failure";
      RestartSec = 10;
      Environment = [
        "PYTHONUNBUFFERED=1"
      ];
    };

    Install.WantedBy = [ "graphical-session.target" ];
  };
}

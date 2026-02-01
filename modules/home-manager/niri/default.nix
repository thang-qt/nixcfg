{ lib, pkgs, ... }:
{
  xdg.configFile."niri/config.kdl".source = ./config.kdl;

  systemd.user.services.polkit-kde-authentication-agent-1 = {
    Unit = {
      Description = "KDE polkit authentication agent";
      Wants = [ "graphical-session.target" ];
      After = [ "graphical-session.target" ];
      ConditionEnvironment = "XDG_CURRENT_DESKTOP=niri";
    };
    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
    Service = {
      Type = "simple";
      ExecStart = "${pkgs.kdePackages.polkit-kde-agent-1}/libexec/polkit-kde-authentication-agent-1";
      Restart = "on-failure";
      RestartSec = 1;
      TimeoutStopSec = 10;
    };
  };
}

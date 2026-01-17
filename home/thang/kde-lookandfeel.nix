{
  pkgs,
  ...
}:
{
  systemd.user.services = {
    kde-lookandfeel-light = {
      Unit.Description = "Switch KDE to light theme";
      Service = {
        Type = "oneshot";
        Environment = [
          "QT_DEBUG_PLUGINS=1"
          "LIBGL_ALWAYS_INDIRECT="
          "DISPLAY=:0"
        ];
        ExecStart = "${pkgs.kdePackages.plasma-workspace}/bin/lookandfeeltool -a org.kde.breeze.desktop";
      };
    };
    kde-lookandfeel-dark = {
      Unit.Description = "Switch KDE to dark theme";
      Service = {
        Type = "oneshot";
        Environment = [
          "QT_DEBUG_PLUGINS=1"
          "LIBGL_ALWAYS_INDIRECT="
          "DISPLAY=:0"
        ];
        ExecStart = "${pkgs.kdePackages.plasma-workspace}/bin/lookandfeeltool -a org.kde.breezedark.desktop";
      };
    };
  };

  systemd.user.timers = {
    kde-lookandfeel-light = {
      Unit.Description = "Switch KDE to light theme at 6am";
      Timer = {
        OnCalendar = "06:00";
        Persistent = true;
      };
      Install.WantedBy = [ "timers.target" ];
    };
    kde-lookandfeel-dark = {
      Unit.Description = "Switch KDE to dark theme at 6pm";
      Timer = {
        OnCalendar = "18:00";
        Persistent = true;
      };
      Install.WantedBy = [ "timers.target" ];
    };
  };
}

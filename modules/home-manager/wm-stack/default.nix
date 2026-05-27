{ pkgs, ... }:
{
  imports = [
    ./fuzzel.nix
    ./waybar.nix
    ./mako.nix
    ./wallpaper.nix
  ];

  home.packages = with pkgs; [
    libnotify
    playerctl
    (writeShellScriptBin "notify-volume" ''
      set -euo pipefail

      muted="$(${wireplumber}/bin/wpctl get-volume @DEFAULT_AUDIO_SINK@ | ${gnugrep}/bin/grep -q MUTED && echo true || echo false)"
      volume="$(${wireplumber}/bin/wpctl get-volume @DEFAULT_AUDIO_SINK@ | ${gnused}/bin/sed -E 's/Volume: ([0-9.]+).*/\1/')"
      percent="$(${gawk}/bin/awk -v v="$volume" 'BEGIN { printf "%d", v * 100 }')"

      if [ "$muted" = true ]; then
        ${libnotify}/bin/notify-send \
          --app-name=volume \
          --replace-id=91190 \
          --urgency=low \
          "Volume" \
          "muted"
      else
        ${libnotify}/bin/notify-send \
          --app-name=volume \
          --replace-id=91190 \
          --urgency=low \
          --hint=int:value:"$percent" \
          "Volume" \
          "$percent%"
      fi
    '')
  ];

  systemd.user.services.playerctld = {
    Unit = {
      Description = "MPRIS playerctld daemon";
      PartOf = [ "graphical-session.target" ];
      After = [ "graphical-session.target" ];
    };
    Service = {
      ExecStart = "${pkgs.playerctl}/bin/playerctld daemon";
      Restart = "on-failure";
    };
    Install.WantedBy = [ "graphical-session.target" ];
  };
}

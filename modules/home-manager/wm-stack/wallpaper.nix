{ pkgs, ... }:
{
  services.swww.enable = true;

  home.packages = with pkgs; [
    (writeShellScriptBin "cycle-wallpaper" ''
      set -euo pipefail

      wallpaper_dir="$HOME/Pictures/Wallpapers"

      if [ ! -d "$wallpaper_dir" ]; then
        echo "Wallpaper directory does not exist: $wallpaper_dir" >&2
        exit 0
      fi

      wallpaper="$(${findutils}/bin/find "$wallpaper_dir" -type f \
        \( -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.png' -o -iname '*.webp' \) \
        | ${coreutils}/bin/shuf -n 1)"

      if [ -z "$wallpaper" ]; then
        echo "No wallpapers found in: $wallpaper_dir" >&2
        exit 0
      fi

      ${swww}/bin/swww img "$wallpaper" \
        --transition-type any \
        --transition-duration 1
    '')
  ];

  systemd.user.services.swww-wallpaper-cycle = {
    Unit = {
      Description = "Random wallpaper rotation with swww";
      After = [ "swww.service" ];
      Requires = [ "swww.service" ];
    };
    Service = {
      Type = "oneshot";
      ExecStart = "cycle-wallpaper";
    };
  };

  systemd.user.timers.swww-wallpaper-cycle = {
    Unit.Description = "Rotate wallpaper every 2 hours";
    Timer = {
      OnBootSec = "10s";
      OnUnitActiveSec = "2h";
      Unit = "swww-wallpaper-cycle.service";
    };
    Install.WantedBy = [ "timers.target" ];
  };
}

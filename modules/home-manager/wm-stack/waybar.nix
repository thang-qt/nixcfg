{ pkgs, ... }:
{
  programs.waybar = {
    enable = true;
    systemd = {
      enable = true;
      target = "niri.service";
    };
    settings.mainBar = {
      layer = "top";
      position = "top";
      width = 1320;
      margin-top = 8;
      margin-bottom = 0;
      height = 26;
      modules-left = [
        "niri/workspaces"
        "niri/window"
      ];
      modules-center = [ "clock" ];
      modules-right = [
        "mpris"
        "tray"
        "pulseaudio"
        "network"
        "battery"
      ];
      "niri/workspaces" = {
        format = "{index}";
      };
      "niri/window" = {
        format = "{}";
        max-length = 60;
      };
      clock = {
        format = "{:%H:%M  %a %d}";
        tooltip-format = "{:%Y-%m-%d}";
      };
      mpris = {
        format = "{status_icon} {title}";
        format-paused = "{status_icon} {title}";
        format-stopped = "";
        tooltip-format = "{player}: {artist} - {title}";
        max-length = 45;
        status-icons = {
          playing = "";
          paused = "";
          stopped = "";
        };
        player = "playerctld";
        on-click = "${pkgs.playerctl}/bin/playerctl play-pause";
        on-click-right = "${pkgs.playerctl}/bin/playerctl next";
        on-click-middle = "${pkgs.playerctl}/bin/playerctl previous";
      };
      pulseaudio = {
        format = "{icon}  {volume}%";
        format-muted = "󰝟  muted";
        format-icons.default = [
          ""
          ""
          ""
        ];
      };
      network = {
        format-wifi = "󰖩  {essid}";
        format-ethernet = "󰈀  wired";
        format-disconnected = "󰖪  offline";
      };
      battery = {
        format = "{capacity}% {icon}";
        format-charging = "{capacity}% 󰂄";
        format-icons = [
          "󰁺"
          "󰁻"
          "󰁼"
          "󰁽"
          "󰁾"
          "󰁿"
          "󰂀"
          "󰂁"
          "󰂂"
          "󰁹"
        ];
      };
    };
    style = ''
      * {
        border: none;
        border-radius: 0;
        font-family: "Iosevka Nerd Font Mono";
        font-size: 12px;
        min-height: 0;
      }

      image,
      #tray image {
        -gtk-icon-transform: scale(1.15);
      }

      window#waybar {
        background: #2b3339;
        color: #d3c6aa;
      }

      #workspaces button {
        padding: 0 4px;
        color: #859289;
      }

      #workspaces button.active,
      #workspaces button.focused {
        color: #2b3339;
        background: #a7c080;
      }

      #window,
      #clock,
      #mpris,
      #tray,
      #pulseaudio,
      #network,
      #battery {
        padding: 0 8px;
      }

      #mpris,
      #pulseaudio,
      #network,
      #battery {
        margin-left: 4px;
      }

      #mpris.playing {
        color: #a7c080;
      }

      #mpris.paused {
        color: #dbbc7f;
      }

      #mpris,
      #pulseaudio,
      #network,
      #battery {
        font-size: 13px;
      }
    '';
  };
}

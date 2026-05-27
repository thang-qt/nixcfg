{ pkgs, ... }:
{
  home.packages = [ pkgs.mako ];

  xdg.configFile."mako/config".text = ''
    anchor=top-right
    font=Iosevka Nerd Font 11
    margin=8
    padding=8
    border-size=1
    border-radius=0
    background-color=#2b3339ee
    text-color=#d3c6aaff
    border-color=#a7c080ff
    default-timeout=5000
  '';

  # Do not use `services.mako.enable`: the upstream user unit is WantedBy
  # graphical-session.target, which also starts in KDE. Niri starts mako
  # explicitly instead.
  services.mako = {
    enable = false;
    settings = {
      anchor = "top-right";
      font = "Iosevka Nerd Font 11";
      margin = "8";
      padding = "8";
      border-size = 1;
      border-radius = 0;
      background-color = "#2b3339ee";
      text-color = "#d3c6aaff";
      border-color = "#a7c080ff";
      default-timeout = 5000;
    };
  };
}

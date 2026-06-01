{
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

  # Keep mako out of home.packages too: the package installs a D-Bus
  # notification service that KDE can activate from the user profile.
  # Niri starts mako explicitly by absolute store path instead.
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

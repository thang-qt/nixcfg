{ ... }:
{
  programs.alacritty = {
    enable = true;
    theme = "catppuccin_mocha";
    settings = {
      window = {
        padding = {
          x = 12;
          y = 8;
        };
      };
      font = {
        normal = {
          family = "MesloLGM Nerd Font Mono";
          style = "Regular";
        };
        bold = {
          family = "MesloLGM Nerd Font Mono";
          style = "Bold";
        };
        italic = {
          family = "MesloLGM Nerd Font Mono";
          style = "Italic";
        };
        bold_italic = {
          family = "MesloLGM Nerd Font Mono";
          style = "Bold Italic";
        };
        size = 14.0;
      };
    };
  };
}

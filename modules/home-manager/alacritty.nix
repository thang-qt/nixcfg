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
          family = "Iosevka Nerd Font";
          style = "Regular";
        };
        bold = {
          family = "Iosevka Nerd Font";
          style = "Bold";
        };
        italic = {
          family = "Iosevka Nerd Font";
          style = "Italic";
        };
        bold_italic = {
          family = "Iosevka Nerd Font";
          style = "Bold Italic";
        };
        size = 14.0;
      };
    };
  };
}

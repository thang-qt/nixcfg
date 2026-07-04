{...}: {
  programs.alacritty = {
    enable = true;
    settings = {
      colors = {
        primary = {
          background = "#1e1e2e";
          foreground = "#cdd6f4";
        };
        normal = {
          black = "#45475a";
          red = "#f38ba8";
          green = "#a6e3a1";
          yellow = "#f9e2af";
          blue = "#89b4fa";
          magenta = "#f5c2e7";
          cyan = "#94e2d5";
          white = "#bac2de";
        };
        bright = {
          black = "#585b70";
          red = "#f38ba8";
          green = "#a6e3a1";
          yellow = "#f9e2af";
          blue = "#89b4fa";
          magenta = "#f5c2e7";
          cyan = "#94e2d5";
          white = "#a6adc8";
        };
      };
      window = {
        padding = {
          x = 8;
          y = 8;
        };
        dimensions = {
          columns = 110;
          lines = 28;
        };
      };
      font = {
        normal = {
          family = "Iosevka Nerd Font Mono";
          style = "Regular";
        };
        bold = {
          family = "Iosevka Nerd Font Mono";
          style = "Bold";
        };
        italic = {
          family = "Iosevka Nerd Font Mono";
          style = "Italic";
        };
        bold_italic = {
          family = "Iosevka Nerd Font Mono";
          style = "Bold Italic";
        };
        size = 14.0;
      };
    };
  };
}

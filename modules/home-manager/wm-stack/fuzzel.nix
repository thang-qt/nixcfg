{...}: {
  programs.fuzzel = {
    enable = true;
    settings = {
      main = {
        terminal = "alacritty -e";
        font = "Iosevka Nerd Font:size=12";
        width = 48;
        lines = 12;
        horizontal-pad = 8;
        vertical-pad = 8;
        inner-pad = 6;
      };
      colors = {
        background = "1e1e2eff";
        text = "cdd6f4ff";
        prompt = "a6e3a1ff";
        placeholder = "6c7086ff";
        input = "cdd6f4ff";
        match = "f9e2afff";
        selection = "313244ff";
        selection-text = "cdd6f4ff";
        selection-match = "f9e2afff";
        border = "a6e3a1ff";
      };
      border = {
        width = 1;
        radius = 0;
      };
    };
  };
}

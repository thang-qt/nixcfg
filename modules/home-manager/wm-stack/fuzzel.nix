{ ... }:
{
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
        background = "2b3339ff";
        text = "d3c6aaff";
        prompt = "a7c080ff";
        placeholder = "859289ff";
        input = "d3c6aaff";
        match = "dbbc7fff";
        selection = "3a4248ff";
        selection-text = "d3c6aaff";
        selection-match = "dbbc7fff";
        border = "a7c080ff";
      };
      border = {
        width = 1;
        radius = 0;
      };
    };
  };
}

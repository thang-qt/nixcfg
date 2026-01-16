{ pkgs, ... }:
{
  programs.wezterm = {
    enable = true;
    extraConfig = ''
       local config = {}
       if wezterm.config_builder then
         config = wezterm.config_builder()
       end
       config.color_scheme = "Catppuccin Mocha"
       config.hide_tab_bar_if_only_one_tab = true
      return config
    '';
  };
}

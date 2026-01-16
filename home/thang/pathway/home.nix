{
  inputs,
  lib,
  config,
  pkgs,
  ...
}:
{
  imports = [
    ../common.nix
    inputs.self.homeManagerModules.firefox
    inputs.self.homeManagerModules.wezterm
    inputs.self.homeManagerModules.zellij
  ];

  home.packages = with pkgs; [
    zed-editor
    mpv
    wezterm
    spotify
    thunderbird
  ];

}

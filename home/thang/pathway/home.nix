{
  inputs,
  lib,
  config,
  pkgs,
  ...
}:
{
  imports = [
    inputs.spicetify-nix.homeManagerModules.default
    ../common.nix
    inputs.self.homeManagerModules.firefox
    inputs.self.homeManagerModules.wezterm
    inputs.self.homeManagerModules.zellij
    inputs.self.homeManagerModules.spicetify
  ];

  home.packages = with pkgs; [
    zed-editor
    mpv
    wezterm
    thunderbird
    unstable.opencode
  ];

  programs.vscode = {
    enable = true;
    package = pkgs.vscodium.fhs;
  };
}

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
    inputs.self.homeManagerModules.mpv
  ];

  home.packages = with pkgs; [
    zed-editor
    wezterm
    geary
    _1password-cli
    _1password-gui
    unstable.opencode
  ];

  programs.vscode = {
    enable = true;
    package = pkgs.vscodium.fhs;
  };

  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    matchBlocks."*".extraOptions = {
      IdentityAgent = "~/.1password/agent.sock";
    };
  };
}

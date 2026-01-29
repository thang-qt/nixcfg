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
    inputs.sops-nix.homeManagerModules.sops
    ../common.nix
    inputs.self.homeManagerModules.opencode
    inputs.self.homeManagerModules.firefox
    inputs.self.homeManagerModules.wezterm
    inputs.self.homeManagerModules.zellij
    inputs.self.homeManagerModules.spicetify
    inputs.self.homeManagerModules.mpv
    inputs.self.homeManagerModules.rescrobbled
  ];

  home.packages = with pkgs; [
    zed-editor
    wezterm
    thunderbird
    _1password-cli
    _1password-gui
    vacuum-tube
    gh
    unstable.codex
    unstable.gemini-cli-bin
    ungoogled-chromium
    heroic
    lutris
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

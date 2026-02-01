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
    inputs.noctalia.homeModules.default
    ../common.nix
    inputs.self.homeManagerModules.opencode
    inputs.self.homeManagerModules.firefox
    inputs.self.homeManagerModules.alacritty
    inputs.self.homeManagerModules.zellij
    inputs.self.homeManagerModules.spicetify
    inputs.self.homeManagerModules.mpv
    inputs.self.homeManagerModules.rescrobbled
    inputs.self.homeManagerModules.niri
    inputs.self.homeManagerModules.noctalia
  ];

  home.packages = with pkgs; [
    zed-editor
    alacritty
    quickshell
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
    jetbrains.idea
    hubstaff
    qbittorrent
    cider
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

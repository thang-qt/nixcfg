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
    inputs.self.homeManagerModules.zathura
  ];

  home.packages = with pkgs; [
    alacritty
    quickshell
    thunderbird
    vacuum-tube
    gh
    unstable.codex
    unstable.antigravity-fhs
    ungoogled-chromium
    heroic
    lutris
    hubstaff
    qbittorrent
    cider
    obsidian
  ];

  programs.vscode = {
    enable = true;
    package = pkgs.vscodium.fhs;
  };

  programs.git = {
    lfs.enable = true;
    settings.push.autoSetupRemote = true;
  };

  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    matchBlocks."*".extraOptions = {
      IdentityAgent = "~/.1password/agent.sock";
    };
  };
}

{
  inputs,
  lib,
  config,
  pkgs,
  ...
}:
{
  nixpkgs.overlays = [
    inputs.self.overlays.llm-agents
  ];

  imports = [
    inputs.spicetify-nix.homeManagerModules.default
    inputs.sops-nix.homeManagerModules.sops
    ../common.nix
    inputs.self.homeManagerModules.pi
    inputs.self.homeManagerModules.firefox
    inputs.self.homeManagerModules.zen
    inputs.self.homeManagerModules.alacritty
    inputs.self.homeManagerModules.zellij
    inputs.self.homeManagerModules.spicetify
    inputs.self.homeManagerModules.mpv
    inputs.self.homeManagerModules.rescrobbled
    inputs.self.homeManagerModules.trakt-scrobbler
    inputs.self.homeManagerModules.niri
    inputs.self.homeManagerModules.wm-stack
    inputs.self.homeManagerModules.zathura
    inputs.self.homeManagerModules.yazi
    inputs.self.homeManagerModules.zed
    ./pi.nix
  ];

  home.packages = with pkgs; [
    alacritty
    thunderbird
    vacuum-tube
    gh
    llm-agents.codex
    unstable.antigravity-fhs
    inputs.helium.packages.${pkgs.stdenv.hostPlatform.system}.helium
    hubstaff
    qbittorrent
    cider
    obsidian
    vscode
  ];

  programs.git = {
    lfs.enable = true;
    settings.push.autoSetupRemote = true;
  };

  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    settings."*" = {
      IdentityAgent = "~/.1password/agent.sock";
    };
  };
}

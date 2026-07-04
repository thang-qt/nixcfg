{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  nixpkgs.overlays = [
    inputs.self.overlays.llm-agents
  ];

  imports = [
    inputs.spicetify-nix.homeManagerModules.default
    inputs.sops-nix.homeManagerModules.sops
    ../common.nix
    inputs.self.homeManagerModules.pi
    inputs.self.homeManagerModules.firefox
    inputs.self.homeManagerModules.alacritty
    inputs.self.homeManagerModules.zellij
    inputs.self.homeManagerModules.spicetify
    inputs.self.homeManagerModules.mpv
    inputs.self.homeManagerModules.rescrobbled
    inputs.self.homeManagerModules.niri
    inputs.self.homeManagerModules.wm-stack
    inputs.self.homeManagerModules.zathura
    inputs.self.homeManagerModules.yazi
    inputs.self.homeManagerModules.zed
  ];

  home.packages = with pkgs; [
    alacritty
    thunderbird
    vacuum-tube
    gh
    llm-agents.codex
    llm-agents.crush
    unstable.antigravity-fhs
    ungoogled-chromium
    hubstaff
    qbittorrent
    cider
    obsidian
    vscode
  ];


  programs.pi-coding-agent = {
    enable = true;
    settings = {
      theme = "dark";
      defaultProvider = "proxy";
      defaultModel = "cx/gpt-5.5-medium";
      defaultThinkingLevel = "medium";
      warnings.anthropicExtraUsage = false;
    };
    models = null;
    subagents.settings = {
      agentOverrides = {
        reviewer = {
          thinking = "high";
          inheritProjectContext = false;
        };
        oracle = {
          thinking = "high";
        };
      };
    };
  };

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

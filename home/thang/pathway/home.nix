{
  inputs,
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
    inputs.self.homeManagerModules.zen
    inputs.self.homeManagerModules.alacritty
    inputs.self.homeManagerModules.zellij
    inputs.self.homeManagerModules.spicetify
    inputs.self.homeManagerModules.mpv
    inputs.self.homeManagerModules.rescrobbled
    inputs.self.homeManagerModules.trakt-scrobbler
    # inputs.self.homeManagerModules.niri
    # inputs.self.homeManagerModules.noctalia
    inputs.self.homeManagerModules.zathura
    inputs.self.homeManagerModules.yazi
    inputs.self.homeManagerModules.zed
    inputs.self.homeManagerModules.wezterm
    ../pi.nix
  ];

  sops.age = {
    keyFile = "${config.home.homeDirectory}/.config/sops/age/keys.txt";
    sshKeyPaths = [];
  };

  home.packages = with pkgs; [
    alacritty
    python3
    thunderbird
    vacuum-tube
    gh
    llm-agents.codex
    llm-agents.antigravity-cli
    inputs.helium.packages.${pkgs.stdenv.hostPlatform.system}.helium
    hubstaff
    qbittorrent
    cider
    obsidian
    vscode
    koreader
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

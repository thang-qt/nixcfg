{
  inputs,
  config,
  pkgs,
  ...
}: let
  # KOReader's SDL Wayland backend currently crashes in Mesa's thread cleanup
  # during normal exit. Keep this application on XWayland until that is fixed.
  koreaderX11 = pkgs.symlinkJoin {
    name = "koreader-x11-${pkgs.koreader.version}";
    paths = [pkgs.koreader];
    nativeBuildInputs = [pkgs.makeWrapper];
    postBuild = ''
      rm "$out/bin/koreader"
      makeWrapper ${pkgs.koreader}/bin/koreader "$out/bin/koreader" \
        --set SDL_VIDEODRIVER x11
    '';
  };
in {
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
    koreaderX11
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

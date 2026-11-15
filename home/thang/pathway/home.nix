{
  inputs,
  config,
  pkgs,
  ...
}: {
  imports = [
    inputs.spicetify-nix.homeManagerModules.default
    inputs.sops-nix.homeManagerModules.sops
    ../common.nix
    # inputs.self.homeManagerModules.pi
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
    # ../pi.nix
  ];

  sops.age = {
    keyFile = "${config.home.homeDirectory}/.config/sops/age/keys.txt";
    sshKeyPaths = [];
  };

  home.packages = with pkgs; [
    alacritty
    kairos-desktop
    sesame-link
    unstable.t3code
    python3
    prismlauncher-offline
    unstable.sgdboop
    thunderbird
    vacuum-tube
    gh
    unstable.awscli2
    unstable.codex
    unstable.docker-sbx
    unstable.pi-coding-agent
    unstable.antigravity-cli
    inputs.helium.packages.${pkgs.stdenv.hostPlatform.system}.helium
    qbittorrent
    cider
    obsidian
    vscode
    koreader
    drawy
    wl-clipboard
  ];

  xdg.dataFile."applications/org.kairos.Kairos.desktop".source = "${pkgs.kairos-desktop}/share/applications/org.kairos.Kairos.desktop";

  # WARP's tray app has its own login autostart, separate from the system daemon.
  xdg.configFile."autostart/com.cloudflare.WarpTaskbar.desktop".text = ''
    [Desktop Entry]
    Type=Application
    Name=Cloudflare Zero Trust
    Hidden=true
  '';

  programs.git = {
    lfs.enable = true;
    settings.push.autoSetupRemote = true;
  };

  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    settings = {
      "sbx_cloud" = {
        HostName = "sbx_gateway";
        HostKeyAlias = "sbx_gateway";
        IdentityAgent = "~/.ssh/sandboxes/%r/agent.sock";
        IdentityFile = "~/.ssh/sandboxes/%r/%r";
        CertificateFile = "~/.ssh/sandboxes/%r/%r-cert.pub";
        UserKnownHostsFile = "~/.ssh/sandboxes/known_hosts";
        ProxyCommand = "${pkgs.unstable.docker-sbx}/bin/sbx --cloud ssh-connect '%r' %h %p";
        IdentitiesOnly = false;
        ControlMaster = "no";
        ControlPath = "none";
      };
      "*" = {
        IdentityAgent = "~/.1password/agent.sock";
      };
    };
  };
}

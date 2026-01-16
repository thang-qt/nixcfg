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
    mpv
    wezterm
    thunderbird
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
    extraConfig = ''
      Host *
        IdentityAgent ~/.1password/agent.sock
    '';
  };

  programs.git.settings = {
    gpg.format = "ssh";
    "gpg \"ssh\"" = {
      program = "${lib.getExe' pkgs._1password-gui "op-ssh-sign"}";
    };
    commit.gpgsign = true;
  };
}

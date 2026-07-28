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
    inputs.sops-nix.homeManagerModules.sops
    ../common.nix
    inputs.self.homeManagerModules.pi
    inputs.self.homeManagerModules.zellij
  ];

  home.packages = with pkgs; [
    gh
    uv
  ];

  programs.pi-coding-agent = {
    enable = true;
    extraPackages = [];
  };
}

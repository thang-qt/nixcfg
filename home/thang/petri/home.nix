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
    ../common.nix
    inputs.self.homeManagerModules.pi
    inputs.self.homeManagerModules.zellij
    ../pi.nix
  ];

  home.packages = with pkgs; [
    gh
    uv
  ];

}

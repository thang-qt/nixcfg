{
  inputs,
  pkgs,
  ...
}: {
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

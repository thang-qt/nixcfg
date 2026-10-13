{inputs, ...}: {
  imports = [
    ../common.nix
    inputs.self.homeManagerModules.pi
    inputs.self.homeManagerModules.zellij
    ../pi.nix
  ];
}

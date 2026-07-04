{ pkgs }:

{
  pi-subagents = pkgs.callPackage ./pi-subagents.nix { };
  pi-multi-account = pkgs.callPackage ./pi-multi-account.nix { };
  pi-commandcode-provider = pkgs.callPackage ./pi-commandcode-provider.nix { };
  rpiv-web-tools = pkgs.callPackage ./rpiv-web-tools.nix { };
  rpiv-btw = pkgs.callPackage ./rpiv-btw.nix { };
}

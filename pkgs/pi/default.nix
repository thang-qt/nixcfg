{ pkgs }:

{
  pi-subagents = pkgs.callPackage ./pi-subagents.nix { };
  pi-spark = pkgs.callPackage ./pi-spark.nix { };
  pi-multi-account = pkgs.callPackage ./pi-multi-account.nix { };
  rpiv-web-tools = pkgs.callPackage ./rpiv-web-tools.nix { };
  rpiv-btw = pkgs.callPackage ./rpiv-btw.nix { };
}

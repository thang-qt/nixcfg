pkgs: {
  pano-scrobbler = pkgs.callPackage ./pano-scrobbler-bin.nix { };
  koito = pkgs.callPackage ./koito.nix { };
  cider = pkgs.callPackage ./cider.nix { };
  pi-subagents = pkgs.callPackage ./pi-subagents.nix { };
  rpiv-web-tools = pkgs.callPackage ./rpiv-web-tools.nix { };
  rpiv-btw = pkgs.callPackage ./rpiv-btw.nix { };
}

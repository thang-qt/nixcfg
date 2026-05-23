pkgs: {
  pano-scrobbler = pkgs.callPackage ./pano-scrobbler-bin.nix { };
  koito = pkgs.callPackage ./koito.nix { };
  cider = pkgs.callPackage ./cider.nix { };
  pi-subagents = pkgs.callPackage ./pi-subagents.nix { };
  pi-web-access = pkgs.callPackage ./pi-web-access.nix { };
  rpiv-btw = pkgs.callPackage ./rpiv-btw.nix { };
}

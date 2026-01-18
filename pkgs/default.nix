pkgs: {
  pano-scrobbler = pkgs.callPackage ./pano-scrobbler-bin.nix { };
  koito = pkgs.callPackage ./koito.nix { };
}

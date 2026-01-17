# Custom packages, that can be defined similarly to ones from nixpkgs
# You can build them using 'nix build .#example'
pkgs: {
  # example = pkgs.callPackage ./example { };
  pano-scrobbler = pkgs.callPackage ./pano-scrobbler-bin.nix { };
  koito = pkgs.callPackage ./koito.nix { };
}

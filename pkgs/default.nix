{
  pkgs,
  inputs,
  system,
}:
{
  pano-scrobbler = pkgs.callPackage ./pano-scrobbler-bin.nix {};
  koito = pkgs.callPackage ./koito.nix {};
  cider = pkgs.callPackage ./cider.nix {};
  sesame-link = pkgs.callPackage ./sesame-link.nix {};
  trakt-scrobbler = pkgs.callPackage ./trakt-scrobbler.nix {};
}
// import ./pi {inherit pkgs;}
// (
  if builtins.elem system ["x86_64-linux" "aarch64-linux"]
  then {
    kairos-desktop = inputs.kairos.packages.${system}.kairos-desktop;
  }
  else {}
)

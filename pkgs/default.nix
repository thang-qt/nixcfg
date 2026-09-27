pkgs:
{
  pano-scrobbler = pkgs.callPackage ./pano-scrobbler-bin.nix {};
  koito = pkgs.callPackage ./koito.nix {};
  cider = pkgs.callPackage ./cider.nix {};
  trakt-scrobbler = pkgs.callPackage ./trakt-scrobbler.nix {};
  jorts = pkgs.callPackage ./jorts.nix {};
  mixer = pkgs.callPackage ./mixer.nix {};
  moobo = pkgs.callPackage ./moobo.nix {};
}
// import ./pi {inherit pkgs;}

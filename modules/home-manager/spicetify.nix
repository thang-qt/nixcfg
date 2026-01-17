{
  inputs,
  pkgs,
  ...
}:
let
  spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.stdenv.hostPlatform.system};
in
{
  programs.spicetify = {
    enable = true;
    spotifyPackage = pkgs.unstable.spotify;
    spicetifyPackage = pkgs.unstable.spicetify-cli;
    theme = spicePkgs.themes.starryNight;
    enabledExtensions = with spicePkgs.extensions; [
      shuffle
      catJamSynced
    ];
    enabledCustomApps = with spicePkgs.apps; [
      lyricsPlus
    ];
    enabledSnippets = with spicePkgs.snippets; [
      duck
      nyanCatProgressBar
    ];
  };
}

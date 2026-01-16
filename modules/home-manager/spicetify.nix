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
    spotifyPackage = pkgs.spotify;
    theme = spicePkgs.themes.starryNight;
    enabledExtensions = with spicePkgs.extensions; [
      shuffle
      popupLyrics
      keyboardShortcut
      betterGenres
    ];
    enabledCustomApps = with spicePkgs.apps; [
      lyricsPlus
    ];
  };
}

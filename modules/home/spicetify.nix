{ inputs, pkgs, ... }:
let
  ohitstom = pkgs.fetchFromGitHub {
    owner = "ohitstom";
    repo = "spicetify-extensions";
    rev = "061b89e92d8bd12e90a4f5f347889bf7826dbdb0";
    sha256 = "12birf9wsw6zdfdhigiqxxza8bzm78vfyj4qsbisda7da6lfms7w";
  };
  spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.system};
in
{

  programs.spicetify = {
    enable = true;
    theme = spicePkgs.themes.starryNight;
    # colorScheme = "mocha";

    enabledExtensions = with spicePkgs.extensions; [
      fullScreen
      shuffle
      popupLyrics
      keyboardShortcut
      betterGenres
      ({
        src = ohitstom + "/immersiveView";
        name = "immersiveView.js";
      })
    ];

    enabledCustomApps = with spicePkgs.apps; [
      lyricsPlus
    ];
  };
}

# Add your reusable home-manager modules to this directory, on their own file (https://nixos.wiki/wiki/Module).
# These should be stuff you would like to share with others, not your personal configurations.
{
  git = import ./git.nix;
  helix = import ./helix.nix;
  firefox = import ./firefox.nix;
  wezterm = import ./wezterm.nix;
  zellij = import ./zellij;
  fish = import ./fish.nix;
  spicetify = import ./spicetify.nix;
  mpv = import ./mpv.nix;
  opencode = import ./opencode.nix;
  rescrobbled = import ./rescrobbled.nix;
  niri = import ./niri;
  noctalia = import ./noctalia.nix;
}

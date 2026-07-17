# Add your reusable home-manager modules to this directory, on their own file (https://nixos.wiki/wiki/Module).
# These should be stuff you would like to share with others, not your personal configurations.
{
  git = import ./git.nix;
  helix = import ./helix.nix;
  firefox = import ./firefox.nix;
  zen = import ./zen.nix;
  alacritty = import ./alacritty.nix;
  zellij = import ./zellij;
  fish = import ./fish.nix;
  spicetify = import ./spicetify.nix;
  mpv = import ./mpv.nix;
  opencode = import ./opencode.nix;
  pi = import ./pi.nix;
  rescrobbled = import ./rescrobbled.nix;
  trakt-scrobbler = import ./trakt-scrobbler.nix;
  niri = import ./niri;
  wm-stack = import ./wm-stack;
  zathura = import ./zathura.nix;
  yazi = import ./yazi.nix;
  zed = import ./zed.nix;
}

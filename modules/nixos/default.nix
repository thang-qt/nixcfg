# Add your reusable NixOS modules to this directory, on their own file (https://nixos.wiki/wiki/Module).
# These should be stuff you would like to share with others, not your personal configurations.
{
  common = import ./common.nix;
  nginx = import ./nginx.nix;
  open-webui = import ./open-webui.nix;
  readn = import ./readn.nix;
  bluetooth = import ./bluetooth.nix;
  auto-cpufreq = import ./auto-cpufreq.nix;
  koito = import ./koito.nix;
  restic = import ./restic.nix;
  gaming = import ./gaming.nix;
}

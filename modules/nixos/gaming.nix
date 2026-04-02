{
  config,
  lib,
  pkgs,
  ...
}:

{
  programs.steam = {
    enable = true;
    extraCompatPackages = with pkgs; [
      proton-ge-bin
    ];
  };

  environment.systemPackages = with pkgs; [
    heroic
  ];

  programs.gamemode.enable = true;
}

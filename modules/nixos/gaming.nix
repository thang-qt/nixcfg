{ config, lib, pkgs, ... }:

{
  programs.steam = {
    enable = true;
  };

  programs.gamemode.enable = true;
}

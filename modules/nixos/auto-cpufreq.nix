{ lib, ... }:
{
  programs.auto-cpufreq = {
    enable = lib.mkDefault true;
    settings = {
      battery = {
        governor = "powersave";
        turbo = "never";
      };
      charger = {
        governor = "performance";
        turbo = "auto";
      };
    };
  };
}

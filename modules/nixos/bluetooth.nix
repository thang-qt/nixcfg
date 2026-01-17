{ lib, ... }:
{
  hardware.bluetooth.enable = lib.mkDefault true;
  hardware.bluetooth.settings = {
    General = {
      Experimental = true;
    };
  };

  services.pipewire = {
    wireplumber.enable = true;
    wireplumber.extraConfig."10-bluez" = {
      "monitor.bluez.properties" = {
        "bluez5.enable-sbc-xq" = true;
        "bluez5.enable-msbc" = true;
        "bluez5.enable-hw-volume" = true;
        "bluez5.a2dp.ldac.quality" = "auto";
      };
    };
  };
}

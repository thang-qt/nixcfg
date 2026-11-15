{pkgs, ...}: {
  programs.steam = {
    enable = true;
    extraCompatPackages = with pkgs; [
      proton-ge-bin
    ];
  };

  environment.systemPackages = with pkgs; [
    bubblewrap
    fuse-overlayfs
    gamescope
    psmisc
    wineWow64Packages.stagingFull
    winetricks
  ];

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  programs.gamemode.enable = true;
}

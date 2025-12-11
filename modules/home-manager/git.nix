{ pkgs, ... }:
{
  programs.git = {
    enable = true;
    package = pkgs.gitFull;
    userName = "Quang Thang";
    userEmail = "thang@thangqt.com";
    extraConfig = {
      credential.helper = "libsecret";
    };
  };
}

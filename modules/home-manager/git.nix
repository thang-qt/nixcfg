{ pkgs, ... }:
{
  programs.git = {
    enable = true;
    package = pkgs.gitFull;
    settings = {
      user = {
        name = "Quang Thang";
        email = "thang@thangqt.com";
      };
      credential.helper = "libsecret";
    };
  };
}

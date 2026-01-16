{ pkgs, ... }:
{
  programs.mpv = {
    enable = true;

    package = pkgs.mpv-unwrapped.wrapper {
      scripts = with pkgs.mpvScripts; [
        uosc
        youtube-upnext
        mpv-cheatsheet
        sponsorblock
        thumbfast
        quality-menu
        autosubsync-mpv
      ];

      mpv = pkgs.mpv-unwrapped.override {
        waylandSupport = true;
      };
    };

    config = {
      profile = "high-quality";
      ytdl-format = "bestvideo+bestaudio";
    };
  };
}

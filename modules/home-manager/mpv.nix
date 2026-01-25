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
      slang = "vie,vi,eng,en";
      cache = "yes";
      demuxer-max-bytes = "4G";
      cache-backbuffer = "yes";
      demuxer-max-back-bytes = "1G";
      keep-open = "yes";
      keep-open-pause = "yes";
      save-position-on-quit = "yes";
      sub-auto = "fuzzy";
    };
  };
}

{ pkgs, ... }:
{
  programs.mpv = {
    enable = true;

    package = pkgs.mpv.override {
      mpv-unwrapped = pkgs.mpv-unwrapped.override {
        waylandSupport = true;
      };
      scripts = with pkgs.mpvScripts; [
        uosc
        youtube-upnext
        mpv-cheatsheet-ng
        sponsorblock
        thumbfast
        quality-menu
        autosubsync-mpv
      ];
    };

    config = {
      profile = "high-quality";
      ytdl-format = "bestvideo+bestaudio";
      slang = "vie,vi,eng,en";
      cache = "yes";
      demuxer-max-bytes = "4G";
      demuxer-max-back-bytes = "1G";
      keep-open = "yes";
      keep-open-pause = "yes";
      save-position-on-quit = "yes";
      # When opening one local file, create a playlist from sibling media files so playback advances.
      autocreate-playlist = "same";
      # Required by Trakt Scrobbler for mpv progress/file tracking.
      input-ipc-server = "/run/user/1000/.umpv";
      sub-auto = "fuzzy";
    };
  };
}

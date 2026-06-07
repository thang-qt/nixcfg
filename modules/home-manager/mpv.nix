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
      sub-auto = "fuzzy";
    };
  };
}

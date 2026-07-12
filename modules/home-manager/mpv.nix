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
      # Keep mpv alive when started without files, so keep-session can restore the last file/session.
      idle = "yes";
      # When opening one local file, create a playlist from sibling media files so playback advances.
      autocreate-playlist = "same";
      # Required by Trakt Scrobbler for mpv progress/file tracking.
      input-ipc-server = "/run/user/1000/.umpv";
      sub-auto = "fuzzy";
    };
  };

  # Restore the last played file/session when launching `mpv` without arguments.
  # Source: https://github.com/CogentRedTester/mpv-scripts/blob/master/keep-session.lua
  home.file.".config/mpv/scripts/keep-session.lua".source = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/CogentRedTester/mpv-scripts/master/keep-session.lua";
    hash = "sha256-kRM5qhU4rZOEnCSxpiO0vaEVjNb/jOPUiCIH9+8mQLc=";
  };

  home.file.".config/mpv/script-opts/keep_session.conf".text = ''
    auto_save=yes
    auto_load=yes
    load_playlist=no
    maintain_pos=yes
  '';
}

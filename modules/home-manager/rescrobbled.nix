{
  config,
  ...
}:
{
  sops.secrets.rescrobbled-listenbrainz-token = {
    sopsFile = ../../secrets/rescrobbled.yaml;
    format = "yaml";
    key = "listenbrainz_token";
  };

  sops.templates."rescrobbled-config" = {
    content = ''
      min-play-time = 30
      use-track-start-timestamp = false

      [[listenbrainz]]
      url = "https://koito.thangqt.com/apis/listenbrainz/1/"
      token = "${config.sops.placeholder.rescrobbled-listenbrainz-token}"
    '';
    path = "${config.xdg.configHome}/rescrobbled/config.toml";
  };

  services.rescrobbled.enable = true;

  systemd.user.services.rescrobbled = {
    Unit = {
      After = [ "network-online.target" "sops-nix.service" ];
      Wants = [ "network-online.target" ];
      Requires = [ "sops-nix.service" ];
    };
  };
}

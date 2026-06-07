{
  config,
  pkgs,
  ...
}:
let
  rescrobbled = pkgs.rescrobbled.overrideAttrs (old: let
    version = "auto-reconnect";
    src = pkgs.fetchFromGitHub {
      owner = "marius851000";
      repo = "rescrobbled";
      rev = "1fc643b888c8ad2eb46c53a25b6f8f1da4f38b3d";
      hash = "sha256-OXLJvPwEWqrzRdEZlBv6eb3TfVaA7ujbAAoeFq2BHK4=";
    };
    cargoHash = "sha256-ZawdZdP87X7xMdSdZ1VJDJxz7dBGVYo+8jR8qb2Jgq8=";
  in {
    inherit version src cargoHash;
    cargoDeps = pkgs.rustPlatform.fetchCargoVendor {
      pname = "rescrobbled";
      inherit version src;
      hash = cargoHash;
    };
  });
in
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

  services.rescrobbled = {
    enable = true;
    package = rescrobbled;
  };

  systemd.user.services.rescrobbled = {
    Unit = {
      After = [
        "network-online.target"
        "sops-nix.service"
      ];
      Wants = [ "network-online.target" ];
      Requires = [ "sops-nix.service" ];
    };
  };
}

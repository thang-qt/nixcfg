{ config, lib, pkgs, ... }:
let
  cfg = config.custom_modules.koito;
  stateDir = "/var/lib/koito";
  configDir = "${stateDir}/config";
  dbName = "koito";
  dbUser = "koito";
in
{
  options.custom_modules.koito = {
    enable = lib.mkEnableOption "Koito scrobbler service";

    port = lib.mkOption {
      type = lib.types.port;
      default = 4110;
      description = "Port for Koito to listen on";
    };

    allowedHosts = lib.mkOption {
      type = lib.types.str;
      default = "office-desktop.tail5ca7.ts.net,localhost,127.0.0.1";
      description = "Comma-separated list of allowed hosts";
    };

    subsonicUrl = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = "Subsonic server URL (for artwork fetching from Navidrome)";
    };

    subsonicParamsFile = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      description = "Path to file containing KOITO_SUBSONIC_PARAMS (u=user&t=token&s=salt)";
    };

    defaultUsername = lib.mkOption {
      type = lib.types.str;
      default = "admin";
      description = "Default admin username";
    };

    defaultPasswordFile = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      description = "Path to file containing default admin password";
    };

    configureNavidrome = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Automatically configure Navidrome to scrobble to Koito";
    };
  };

  config = lib.mkIf cfg.enable {
    users.users.koito = {
      isSystemUser = true;
      group = "koito";
      home = stateDir;
      createHome = true;
      description = "Koito scrobbler service user";
    };

    users.groups.koito = { };

    systemd.tmpfiles.rules = [
      "d ${stateDir} 0750 koito koito -"
      "d ${configDir} 0750 koito koito -"
      "d ${configDir}/import 0750 koito koito -"
      "d ${configDir}/images 0750 koito koito -"
    ];

    services.postgresql.enable = true;
    services.postgresql.ensureDatabases = [ dbName ];
    services.postgresql.ensureUsers = [
      {
        name = dbUser;
        ensureDBOwnership = true;
      }
    ];
    services.postgresql.authentication = lib.mkAfter ''
      local ${dbName} ${dbUser} peer
    '';

    systemd.services.koito = {
      description = "Koito ListenBrainz Scrobbler";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" "postgresql.service" ];
      requires = [ "postgresql.service" ];

      environment =
        {
          KOITO_DATABASE_URL = "postgres:///${dbName}?host=/run/postgresql";
          KOITO_ALLOWED_HOSTS = cfg.allowedHosts;
          KOITO_LISTEN_PORT = toString cfg.port;
          KOITO_CONFIG_DIR = configDir;
          KOITO_BIND_ADDR = "127.0.0.1";
          KOITO_LOG_LEVEL = "info";
          KOITO_DEFAULT_USERNAME = cfg.defaultUsername;
          KOITO_DEFAULT_THEME = "urim";
          KOITO_LOGIN_GATE = "true";
        }
        // lib.optionalAttrs (cfg.subsonicUrl != null) {
          KOITO_SUBSONIC_URL = cfg.subsonicUrl;
        };

      serviceConfig = {
        Type = "simple";
        User = "koito";
        Group = "koito";
        WorkingDirectory = "${pkgs.koito}/share/koito";
        ExecStart = "${pkgs.koito}/bin/koito";
        Restart = "on-failure";
        RestartSec = "10s";

        NoNewPrivileges = true;
        PrivateTmp = true;
        ProtectSystem = "strict";
        ProtectHome = true;
        ReadWritePaths = [ stateDir ];

        EnvironmentFile = lib.mkIf (cfg.subsonicParamsFile != null) [
          cfg.subsonicParamsFile
        ];

        LoadCredential = lib.mkIf (cfg.defaultPasswordFile != null) [
          "password:${cfg.defaultPasswordFile}"
        ];
      };

      preStart = lib.mkIf (cfg.defaultPasswordFile != null) ''
        if [ -f "$CREDENTIALS_DIRECTORY/password" ]; then
          export KOITO_DEFAULT_PASSWORD=$(cat "$CREDENTIALS_DIRECTORY/password")
        fi
      '';
    };

    services.navidrome.settings = lib.mkIf (
      cfg.configureNavidrome
      && config.services.navidrome.enable
      && !config.custom_modules.multi-scrobbler.enable
    ) {
      "ListenBrainz.Enabled" = true;
      "ListenBrainz.BaseURL" = "http://127.0.0.1:${toString cfg.port}/apis/listenbrainz/1";
    };
  };
}

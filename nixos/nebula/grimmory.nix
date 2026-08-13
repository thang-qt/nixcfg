{
  config,
  pkgs,
  ...
}: let
  dataDir = "/srv/grimmory";
  backupDir = "${dataDir}/backup-work";
  databaseDump = "${backupDir}/grimmory.sql.zst";
  networkName = "grimmory";
  networkService = "grimmory-network";
  networkUnit = "${networkService}.service";
  databaseService = "grimmory-mariadb";
  databaseUnit = "${databaseService}.service";
  applicationService = "grimmory";
  applicationUnit = "${applicationService}.service";
  grimmorySecretsFile = ../../secrets/nebula/grimmory.yaml;
  resticSecretsFile = ../../secrets/nebula/restic.yaml;
in {
  sops.secrets = {
    grimmory-db-password = {
      sopsFile = grimmorySecretsFile;
      format = "yaml";
      key = "db_password";
      mode = "0400";
      owner = "root";
      restartUnits = [
        databaseUnit
        applicationUnit
        "grimmory-db-dump.service"
      ];
    };

    grimmory-db-root-password = {
      sopsFile = grimmorySecretsFile;
      format = "yaml";
      key = "db_root_password";
      mode = "0400";
      owner = "root";
      restartUnits = [databaseUnit];
    };

    grimmory-restic-password = {
      sopsFile = resticSecretsFile;
      format = "yaml";
      key = "restic_password";
      mode = "0400";
      owner = "root";
      restartUnits = [
        "restic-backups-grimmory.service"
        "restic-backups-koito.service"
        "restic-backups-kairos.service"
        "restic-backups-readn.service"
      ];
    };

    grimmory-s3-access-key = {
      sopsFile = resticSecretsFile;
      format = "yaml";
      key = "aws_access_key_id";
      mode = "0400";
      owner = "root";
      restartUnits = [
        "restic-backups-grimmory.service"
        "restic-backups-koito.service"
        "restic-backups-kairos.service"
        "restic-backups-readn.service"
      ];
    };

    grimmory-s3-secret-key = {
      sopsFile = resticSecretsFile;
      format = "yaml";
      key = "aws_secret_access_key";
      mode = "0400";
      owner = "root";
      restartUnits = [
        "restic-backups-grimmory.service"
        "restic-backups-koito.service"
        "restic-backups-kairos.service"
        "restic-backups-readn.service"
      ];
    };
  };

  sops.templates = {
    "grimmory-mariadb-env" = {
      mode = "0400";
      owner = "root";
      content = ''
        MYSQL_ROOT_PASSWORD=${config.sops.placeholder.grimmory-db-root-password}
        MYSQL_PASSWORD=${config.sops.placeholder.grimmory-db-password}
      '';
    };

    "grimmory-env" = {
      mode = "0400";
      owner = "root";
      content = ''
        DATABASE_PASSWORD=${config.sops.placeholder.grimmory-db-password}
      '';
    };

    "grimmory-restic-env" = {
      mode = "0400";
      owner = "root";
      content = ''
        AWS_ACCESS_KEY_ID=${config.sops.placeholder.grimmory-s3-access-key}
        AWS_SECRET_ACCESS_KEY=${config.sops.placeholder.grimmory-s3-secret-key}
      '';
    };

    "grimmory-restic-repository" = {
      mode = "0400";
      owner = "root";
      content = "s3:https://s3-hcm5-r1.longvan.net/backupqt/hostname/nebula/grimmory\n";
    };
  };

  # Grimmory and MariaDB run as UID/GID 1000 inside their containers.
  systemd.tmpfiles.rules = [
    "d ${dataDir} 0755 root root -"
    "d ${dataDir}/data 0750 thang users -"
    "z ${dataDir}/data 0750 thang users -"
    "d ${dataDir}/books 0750 thang users -"
    "z ${dataDir}/books 0750 thang users -"
    "d ${dataDir}/bookdrop 0750 thang users -"
    "z ${dataDir}/bookdrop 0750 thang users -"
    "d ${dataDir}/mariadb 0750 thang users -"
    "z ${dataDir}/mariadb 0750 thang users -"
    "d ${backupDir} 0750 root root -"
  ];

  systemd.services.${networkService} = {
    description = "Create the Grimmory Podman network";
    wantedBy = ["multi-user.target"];
    wants = ["network-online.target"];
    after = ["network-online.target"];

    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = pkgs.writeShellScript "create-grimmory-network" ''
        if ! ${pkgs.podman}/bin/podman network inspect ${networkName} >/dev/null 2>&1; then
          ${pkgs.podman}/bin/podman network create ${networkName}
        fi
      '';
    };
  };

  virtualisation.oci-containers = {
    backend = "podman";

    containers = {
      mariadb = {
        serviceName = "grimmory-mariadb";
        image = "lscr.io/linuxserver/mariadb:11.4.8";
        environment = {
          PUID = "1000";
          PGID = "1000";
          TZ = config.time.timeZone;
          MYSQL_DATABASE = "grimmory";
          MYSQL_USER = "grimmory";
        };
        environmentFiles = [config.sops.templates."grimmory-mariadb-env".path];
        volumes = ["${dataDir}/mariadb:/config"];
        networks = [networkName];
        podman.sdnotify = "healthy";
        extraOptions = [
          "--health-cmd=mariadb-admin ping -h localhost"
          "--health-interval=5s"
          "--health-timeout=5s"
          "--health-retries=10"
        ];
      };

      grimmory = {
        serviceName = "grimmory";
        image = "ghcr.io/grimmory-tools/grimmory:v3.3.1";
        environment = {
          USER_ID = "1000";
          GROUP_ID = "1000";
          TZ = config.time.timeZone;
          DATABASE_URL = "jdbc:mariadb://mariadb:3306/grimmory";
          DATABASE_USERNAME = "grimmory";
          DISK_TYPE = "LOCAL";
          # KOReader's OPDS client cannot handle gzip-compressed responses.
          SERVER_COMPRESSION_ENABLED = "false";
        };
        environmentFiles = [config.sops.templates."grimmory-env".path];
        dependsOn = ["mariadb"];
        ports = ["127.0.0.1:6060:6060"];
        volumes = [
          "${dataDir}/data:/app/data"
          "${dataDir}/books:/books"
          "${dataDir}/bookdrop:/bookdrop"
        ];
        networks = [networkName];
        podman.sdnotify = "healthy";
        extraOptions = [
          "--health-cmd=wget -q --spider http://localhost:6060/api/v1/healthcheck"
          "--health-interval=60s"
          "--health-timeout=10s"
          "--health-start-period=60s"
          "--health-retries=5"
        ];
      };
    };
  };

  systemd.services.${databaseService} = {
    requires = [networkUnit];
    after = [networkUnit];
  };

  systemd.services.${applicationService} = {
    requires = [networkUnit];
    after = [networkUnit];
  };

  systemd.services.grimmory-db-dump = {
    description = "Dump the Grimmory MariaDB database";
    requires = [databaseUnit];
    after = [databaseUnit];

    serviceConfig = {
      Type = "oneshot";
      LoadCredential = ["db-password:${config.sops.secrets.grimmory-db-password.path}"];
      ExecStartPre = pkgs.writeShellScript "wait-for-grimmory-mariadb" ''
        set -euo pipefail
        for _ in $(seq 1 60); do
          if ${pkgs.podman}/bin/podman exec mariadb mariadb-admin ping --silent >/dev/null 2>&1; then
            exit 0
          fi
          sleep 1
        done
        echo "Timed out waiting for Grimmory MariaDB to become ready" >&2
        exit 1
      '';
      ExecStart = pkgs.writeShellScript "dump-grimmory-database" ''
        set -euo pipefail
        umask 0077

        env_file="$(mktemp)"
        tmp_file=""

        cleanup() {
          rm -f "$env_file"
          if [ -n "$tmp_file" ]; then
            rm -f "$tmp_file"
          fi
        }
        trap cleanup EXIT

        db_password="$(<"$CREDENTIALS_DIRECTORY/db-password")"
        printf 'MYSQL_PWD=%s\n' "$db_password" > "$env_file"
        chmod 0600 "$env_file"

        tmp_file="$(mktemp ${backupDir}/grimmory.sql.zst.XXXXXX)"
        ${pkgs.podman}/bin/podman exec \
          --env-file "$env_file" \
          mariadb \
          # The persisted MariaDB 11.4 mysql.proc table is read-only; dumping
          # routines makes the otherwise valid application dump fail.
          mariadb-dump \
          --single-transaction \
          --quick \
          --events \
          --triggers \
          --user=grimmory \
          --databases grimmory \
          | ${pkgs.zstd}/bin/zstd -T0 -c > "$tmp_file"

        chmod 0640 "$tmp_file"
        mv "$tmp_file" ${databaseDump}
        tmp_file=""
      '';
    };
  };

  services.restic.backups.grimmory = {
    initialize = true;
    repositoryFile = config.sops.templates."grimmory-restic-repository".path;
    passwordFile = config.sops.secrets.grimmory-restic-password.path;
    environmentFile = config.sops.templates."grimmory-restic-env".path;

    paths = [
      "${dataDir}/books"
      "${dataDir}/data"
      "${dataDir}/bookdrop"
      databaseDump
    ];

    timerConfig = {
      OnCalendar = "daily";
      Persistent = true;
      RandomizedDelaySec = "15m";
    };

    pruneOpts = [
      "--keep-daily 7"
      "--keep-weekly 4"
      "--keep-monthly 12"
      "--keep-yearly 3"
    ];

    runCheck = false;
    extraBackupArgs = [
      "--exclude-caches"
      "--exclude-if-present .nobackup"
      "--compression auto"
    ];
  };

  systemd.services."restic-backups-grimmory" = {
    requires = ["grimmory-db-dump.service"];
    after = ["grimmory-db-dump.service"];
  };

  services.nginx.virtualHosts."grimmory.thangqt.com" = {
    enableACME = true;
    forceSSL = true;
    # Keep HTTP/1.1 for WebSocket upgrades used by the application.
    http2 = false;

    locations."/" = {
      proxyPass = "http://127.0.0.1:6060";
      proxyWebsockets = true;
      extraConfig = ''
        client_max_body_size 512m;
        proxy_read_timeout 300s;
        proxy_send_timeout 300s;
        # KOReader's OPDS client cannot handle gzip-compressed responses.
        gzip off;
        gzip_static off;
      '';
    };
  };
}

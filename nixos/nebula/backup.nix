{
  config,
  pkgs,
  ...
}: let
  snapshotDir = "/var/lib/nebula-backups";
  koitoDatabase = "/var/lib/koito/config/koito.db";
  koitoSnapshot = "${snapshotDir}/koito.db";
  kairosDatabase = "/var/lib/kairos/kairos.db";
  kairosSnapshot = "${snapshotDir}/kairos.db";
  yarrDatabase = "/var/lib/yarr/storage.db";
  yarrSnapshot = "${snapshotDir}/yarr.db";

  resticPassword = config.sops.secrets.grimmory-restic-password.path;
  resticEnvironment = config.sops.templates."grimmory-restic-env".path;

  pruneOpts = [
    "--keep-daily 7"
    "--keep-weekly 4"
    "--keep-monthly 12"
    "--keep-yearly 3"
  ];

  extraBackupArgs = [
    "--exclude-caches"
    "--exclude-if-present .nobackup"
    "--compression auto"
  ];

  mkSqliteSnapshotService = {
    name,
    service,
    database,
    snapshot,
  }: {
    description = "Create a consistent ${name} SQLite snapshot";
    requires = ["${service}.service"];
    after = ["${service}.service"];

    serviceConfig = {
      Type = "oneshot";
      ExecStart = pkgs.writeShellScript "${name}-sqlite-snapshot" ''
        set -euo pipefail
        umask 0077

        database="${database}"
        snapshot="${snapshot}"
        temporary="$(mktemp "''${snapshot}.XXXXXX")"

        cleanup() {
          rm -f "$temporary"
        }
        trap cleanup EXIT

        test -r "$database"
        ${pkgs.sqlite}/bin/sqlite3 "$database" <<SQL
        .timeout 10000
        .backup '$temporary'
        SQL

        chmod 0640 "$temporary"
        mv "$temporary" "$snapshot"
        trap - EXIT
      '';
    };
  };

  mkResticBackup = {
    repository,
    paths,
    exclude,
  }: {
    initialize = true;
    repositoryFile = config.sops.templates."${repository}-restic-repository".path;
    passwordFile = resticPassword;
    environmentFile = resticEnvironment;

    inherit paths exclude pruneOpts extraBackupArgs;

    timerConfig = {
      OnCalendar = "daily";
      Persistent = true;
      RandomizedDelaySec = "15m";
    };

    runCheck = false;
  };
in {
  systemd.tmpfiles.rules = [
    "d ${snapshotDir} 0750 root root -"
  ];

  sops.templates = {
    "koito-restic-repository" = {
      mode = "0400";
      owner = "root";
      content = "s3:https://s3-hcm5-r1.longvan.net/backupqt/hostname/nebula/koito\n";
    };

    "kairos-restic-repository" = {
      mode = "0400";
      owner = "root";
      content = "s3:https://s3-hcm5-r1.longvan.net/backupqt/hostname/nebula/kairos\n";
    };

    "readn-restic-repository" = {
      mode = "0400";
      owner = "root";
      content = "s3:https://s3-hcm5-r1.longvan.net/backupqt/hostname/nebula/readn\n";
    };
  };

  systemd.services = {
    koito-db-snapshot = mkSqliteSnapshotService {
      name = "koito";
      service = "koito";
      database = koitoDatabase;
      snapshot = koitoSnapshot;
    };

    kairos-db-snapshot = mkSqliteSnapshotService {
      name = "kairos";
      service = "kairos";
      database = kairosDatabase;
      snapshot = kairosSnapshot;
    };

    yarr-db-snapshot = mkSqliteSnapshotService {
      name = "yarr";
      service = "yarr";
      database = yarrDatabase;
      snapshot = yarrSnapshot;
    };
  };

  services.restic.backups = {
    koito = mkResticBackup {
      repository = "koito";
      paths = [
        "/var/lib/koito/config"
        koitoSnapshot
      ];
      exclude = [
        "/var/lib/koito/config/koito.db*"
      ];
    };

    kairos = mkResticBackup {
      repository = "kairos";
      paths = [
        "/var/lib/kairos"
        kairosSnapshot
      ];
      exclude = [
        "/var/lib/kairos/kairos.db*"
      ];
    };

    readn = mkResticBackup {
      repository = "readn";
      paths = [
        "/var/lib/yarr"
        yarrSnapshot
      ];
      exclude = [
        "/var/lib/yarr/storage.db*"
      ];
    };
  };

  systemd.services."restic-backups-koito" = {
    requires = ["koito-db-snapshot.service"];
    after = ["koito-db-snapshot.service"];
  };

  systemd.services."restic-backups-kairos" = {
    requires = ["kairos-db-snapshot.service"];
    after = ["kairos-db-snapshot.service"];
  };

  systemd.services."restic-backups-readn" = {
    requires = ["yarr-db-snapshot.service"];
    after = ["yarr-db-snapshot.service"];
  };
}

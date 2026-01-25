{
  config,
  lib,
  pkgs,
  ...
}:

{
  sops.age.keyFile = "/etc/sops/age/keys.txt";

  sops.secrets = {
    restic-password = {
      sopsFile = ../../secrets/restic.yaml;
      format = "yaml";
      key = "restic_password";
      mode = "0400";
      owner = "root";
    };

    restic-s3-access-key = {
      sopsFile = ../../secrets/restic.yaml;
      format = "yaml";
      key = "aws_access_key_id";
      mode = "0400";
      owner = "root";
    };

    restic-s3-secret-key = {
      sopsFile = ../../secrets/restic.yaml;
      format = "yaml";
      key = "aws_secret_access_key";
      mode = "0400";
      owner = "root";
    };
  };

  sops.templates."restic-env".content = ''
    AWS_ACCESS_KEY_ID=${config.sops.placeholder."restic-s3-access-key"}
    AWS_SECRET_ACCESS_KEY=${config.sops.placeholder."restic-s3-secret-key"}
  '';

  sops.templates."restic-repo".content = ''
    s3:https://s3-hcm5-r1.longvan.net/backupqt/hostname/pathway
  '';

  services.restic.backups = {
    pathway-home = {
      initialize = true;
      repositoryFile = config.sops.templates."restic-repo".path;
      passwordFile = config.sops.secrets.restic-password.path;
      environmentFile = config.sops.templates."restic-env".path;

      paths = [ "/home/thang" ];

      exclude = [
        "/home/thang/.cache"
        "/home/thang/.local/share/Trash"
        "/home/thang/.local/share/docker"
        "/home/thang/.mozilla/firefox/*/cache2"
        "/home/thang/.config/google-chrome/*/Cache"
        "/home/thang/.config/chromium/*/Cache"
        "/home/thang/Downloads"
        "/home/thang/.local/share/Steam"
        "node_modules"
        ".next"
        ".nuxt"
        ".venv"
        ".tox"
        "__pycache__"
        "target/debug"
        "target/release"
        "dist"
        "build"
        ".gradle"
        ".android"
        ".cxx"
        ".cache"
        ".pytest_cache"
        ".mypy_cache"
        ".ruff_cache"
        "*.tmp"
        "*.temp"
        ".DS_Store"
      ];

      timerConfig = {
        OnCalendar = "daily";
        Persistent = true;
        RandomizedDelaySec = "5m";
      };

      pruneOpts = [
        "--keep-daily 7"
        "--keep-weekly 4"
        "--keep-monthly 6"
        "--keep-yearly 2"
      ];

      runCheck = false;

      extraBackupArgs = [
        "--exclude-caches"
        "--exclude-if-present .nobackup"
        "--compression auto"
      ];
    };
  };
}

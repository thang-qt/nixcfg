{
  config,
  lib,
  ...
}: let
  host = config.networking.hostName;
  resticSecretsFile = ../../secrets/${host}/restic.yaml;

  commonExcludes = [
    "/home/thang/.cache"
    "/home/thang/.local/share/Trash"
    "node_modules"
    ".pnpm-store"
    ".pnpm-home/store"
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
    ".npm"
    "Library/PackageCache"
    "Library/ArtifactDB"
    "Library/Bee"
    "Library/Il2cppBuildCache"
    ".pytest_cache"
    ".mypy_cache"
    ".ruff_cache"
    "*.tmp"
    "*.temp"
    ".DS_Store"
  ];

  pathwayExcludes = [
    "/home/thang/.local/share/docker"
    "/home/thang/.local/share/ai-models"
    "/home/thang/.zen/*/cache2"
    "/home/thang/.config/helium/*/Cache"
    "/home/thang/.config/heroic/tools"
    "/home/thang/.config/syncthing/index-v2"
    "/home/thang/.local/share/opencode/bin"
    "/home/thang/.local/share/lutris/runtime"
    "/home/thang/.local/share/uv/python"
    "/home/thang/.local/share/JetBrains/IntelliJIdea2025.2/ml-llm"
    "/home/thang/.local/share/zed/external_agents"
    "/home/thang/.vscode/extensions"
    "/home/thang/.vscode-oss/extensions"
    "/home/thang/.antigravity/extensions"
    "/home/thang/go/pkg/mod"
    "/home/thang/.bun/install/cache"
    "/home/thang/Downloads"
    "/home/thang/Games"
    "/home/thang/Music"
    "/home/thang/Videos"
    "/home/thang/Dev/SQL/.pgdata"
    "/home/thang/.local/share/Steam"
    "/home/thang/.local/share/umu"
    "/home/thang/.local/share/pnpm"
    "/home/thang/Dev/.pnpm-store"
    "/home/thang/.config/**/Cache"
    "/home/thang/.config/**/Code Cache"
    "/home/thang/.config/**/GPUCache"
    "/home/thang/.config/**/DawnGraphiteCache"
    "/home/thang/.config/**/DawnWebGPUCache"
    "/home/thang/.config/**/CachedData"
    "/home/thang/.config/**/CachedExtensionVSIXs"
    "/home/thang/.local/share/**/Cache"
    "/home/thang/.local/share/**/Code Cache"
    "/home/thang/.local/share/**/GPUCache"
    "/home/thang/.local/share/**/DawnGraphiteCache"
    "/home/thang/.local/share/**/DawnWebGPUCache"
    "/home/thang/.local/share/**/CachedData"
    "/home/thang/.local/share/**/CachedExtensionVSIXs"
    "/home/thang/.gemini/**/Cache"
    "/home/thang/.gemini/**/Code Cache"
    "/home/thang/.gemini/**/GPUCache"
    "/home/thang/.gemini/**/DawnGraphiteCache"
    "/home/thang/.gemini/**/DawnWebGPUCache"
    "/home/thang/.betterwright/**/Cache"
    "/home/thang/.betterwright/**/Code Cache"
    "/home/thang/.betterwright/**/GPUCache"
    "/home/thang/.betterwright/**/DawnGraphiteCache"
    "/home/thang/.betterwright/**/DawnWebGPUCache"
  ];
in {
  sops.secrets = {
    restic-password = {
      sopsFile = resticSecretsFile;
      format = "yaml";
      key = "restic_password";
      mode = "0400";
      owner = "root";
    };

    restic-s3-access-key = {
      sopsFile = resticSecretsFile;
      format = "yaml";
      key = "aws_access_key_id";
      mode = "0400";
      owner = "root";
    };

    restic-s3-secret-key = {
      sopsFile = resticSecretsFile;
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
    s3:https://s3-hcm5-r1.longvan.net/backupqt/hostname/${host}
  '';

  services.restic.backups."${host}-home" = {
    initialize = true;
    repositoryFile = config.sops.templates."restic-repo".path;
    passwordFile = config.sops.secrets.restic-password.path;
    environmentFile = config.sops.templates."restic-env".path;

    paths = ["/home/thang"];

    exclude = commonExcludes ++ lib.optionals (host == "pathway") pathwayExcludes;

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
}

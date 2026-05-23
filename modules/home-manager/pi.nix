{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.programs.pi-coding-agent;
  jsonFormat = pkgs.formats.json { };

  defaultSettings = {
    quietStartup = true;
    collapseChangelog = true;
    enableInstallTelemetry = false;
    enableSkillCommands = true;
    compaction = {
      enabled = true;
      reserveTokens = 16384;
      keepRecentTokens = 20000;
    };
    retry = {
      enabled = true;
      maxRetries = 3;
      baseDelayMs = 2000;
      provider.maxRetryDelayMs = 60000;
    };
  };

in
{
  options.programs.pi-coding-agent = {
    enable = lib.mkEnableOption "Pi coding agent";

    package = lib.mkOption {
      type = lib.types.package;
      default = if pkgs ? llm-agents && pkgs.llm-agents ? pi then pkgs.llm-agents.pi else pkgs.pi;
      defaultText = lib.literalExpression "pkgs.llm-agents.pi or pkgs.pi";
      description = "Pi coding agent package to install.";
    };

    extraPackages = lib.mkOption {
      type = lib.types.listOf lib.types.package;
      default = with pkgs; [
        nil
        nixfmt-rfc-style
        nodejs_22
        typescript
        typescript-language-server
        ripgrep
        fd
        gh
      ] ++ lib.optionals stdenv.hostPlatform.isLinux [ wl-clipboard ];
      description = "Extra tools available to Pi and subagent child processes.";
    };

    settings = lib.mkOption {
      type = jsonFormat.type;
      default = { };
      example = {
        defaultProvider = "anthropic";
        defaultModel = "claude-sonnet-4-5";
        defaultThinkingLevel = "medium";
        enabledModels = [ "claude-*" "gpt-*" ];
      };
      description = "Settings written to ~/.pi/agent/settings.json.";
    };

    models = lib.mkOption {
      type = lib.types.nullOr jsonFormat.type;
      default = null;
      example.providers = {
        ollama = {
          baseUrl = "http://127.0.0.1:11434/v1";
          apiKey = "ollama";
          api = "openai-completions";
          models = [{ id = "qwen2.5-coder:32b"; }];
        };
      };
      description = "Optional models.json content for custom providers and model overrides.";
    };

    appendSystem = lib.mkOption {
      type = lib.types.nullOr lib.types.lines;
      default = ''
        # Environment

        This is a Nix/NixOS environment. Prefer `nix shell nixpkgs#<package> -c <command>` for one-off tools. Prefer durable changes in the local project flake/dev shell first, then Home Manager/NixOS config when the tool or setting should be global.
      '';
      description = "Optional global APPEND_SYSTEM.md content appended to Pi's default system prompt. Set to null to stop managing it.";
    };

    agentsMd = lib.mkOption {
      type = lib.types.nullOr lib.types.lines;
      default = null;
      example = ''
        # General

        - Prefer small, focused changes.
        - Verify config options against source or documentation before using them.
      '';
      description = "Optional global AGENTS.md content for Pi. When null, Home Manager does not manage ~/.pi/agent/AGENTS.md.";
    };

    webAccess = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Enable pi-web-access for web search/fetch tools and its web skill.";
      };

      package = lib.mkOption {
        type = lib.types.package;
        default = pkgs.pi-web-access;
        defaultText = lib.literalExpression "pi-web-access fetched from GitHub at v0.10.7";
        description = "Reproducibly fetched pi-web-access package.";
      };
    };

    btw = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Enable @juicesharp/rpiv-btw, providing the /btw slash command.";
      };

      package = lib.mkOption {
        type = lib.types.package;
        default = pkgs.rpiv-btw;
        defaultText = lib.literalExpression "@juicesharp/rpiv-btw fetched from npm at 1.1.5";
        description = "Reproducibly fetched rpiv-btw package.";
      };
    };

    subagents = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Enable the pi-subagents package.";
      };

      package = lib.mkOption {
        type = lib.types.package;
        default = pkgs.pi-subagents;
        defaultText = lib.literalExpression "pi-subagents fetched from GitHub at v0.24.0";
        description = "Reproducibly fetched pi-subagents package.";
      };

      settings = lib.mkOption {
        type = jsonFormat.type;
        default = { };
        example = {
          agentOverrides.reviewer = {
            thinking = "high";
            inheritProjectContext = false;
          };
        };
        description = "Settings merged under the top-level `subagents` key.";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [ cfg.package ] ++ cfg.extraPackages;

    home.sessionVariables = {
      PI_TELEMETRY = "0";
      PI_SKIP_VERSION_CHECK = "1";
    };

    xdg.configFile."pi-coding-agent/module-reference.txt".text = ''
      Pi global config is managed by Home Manager:
      - ~/.pi/agent/settings.json
      - ~/.pi/agent/models.json (if enabled)
      - ~/.pi/agent/AGENTS.md (if programs.pi-coding-agent.agentsMd is set)
      - ~/.pi/agent/APPEND_SYSTEM.md (if programs.pi-coding-agent.appendSystem is set)

      pi-subagents source: ${cfg.subagents.package}
      pi-web-access source: ${cfg.webAccess.package}
      rpiv-btw source: ${cfg.btw.package}
    '';

    home.file.".pi/agent/APPEND_SYSTEM.md" = lib.mkIf (cfg.appendSystem != null) {
      text = cfg.appendSystem;
    };

    home.file.".pi/agent/AGENTS.md" = lib.mkIf (cfg.agentsMd != null) {
      text = cfg.agentsMd;
    };

    home.file.".pi/agent/settings.json".source = jsonFormat.generate "pi-settings.json" (
      lib.recursiveUpdate defaultSettings (
        lib.recursiveUpdate cfg.settings {
          packages = (cfg.settings.packages or [ ])
            ++ lib.optionals cfg.webAccess.enable [ (toString cfg.webAccess.package) ]
            ++ lib.optionals cfg.btw.enable [ (toString cfg.btw.package) ]
            ++ lib.optionals cfg.subagents.enable [ (toString cfg.subagents.package) ];
          subagents = lib.recursiveUpdate (cfg.settings.subagents or { }) cfg.subagents.settings;
        }
      )
    );

    home.file.".pi/agent/models.json" = lib.mkIf (cfg.models != null) {
      source = jsonFormat.generate "pi-models.json" cfg.models;
    };
  };
}

{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  nixpkgs.overlays = [
    inputs.self.overlays.llm-agents
  ];

  imports = [
    inputs.spicetify-nix.homeManagerModules.default
    inputs.sops-nix.homeManagerModules.sops
    ../common.nix
    inputs.self.homeManagerModules.opencode
    inputs.self.homeManagerModules.pi
    inputs.self.homeManagerModules.firefox
    inputs.self.homeManagerModules.alacritty
    inputs.self.homeManagerModules.zellij
    inputs.self.homeManagerModules.spicetify
    inputs.self.homeManagerModules.mpv
    inputs.self.homeManagerModules.rescrobbled
    inputs.self.homeManagerModules.niri
    inputs.self.homeManagerModules.wm-stack
    inputs.self.homeManagerModules.zathura
    inputs.self.homeManagerModules.yazi
    inputs.self.homeManagerModules.zed
  ];

  home.packages = with pkgs; [
    alacritty
    thunderbird
    vacuum-tube
    gh
    llm-agents.codex
    llm-agents.crush
    unstable.antigravity-fhs
    ungoogled-chromium
    hubstaff
    qbittorrent
    cider
    obsidian
    vscode
    (writeShellScriptBin "sync-pi-proxy-models" ''
      set -euo pipefail

      endpoint="http://100.124.93.65:20128/v1"
      out="$HOME/.pi/agent/models.json"

      mkdir -p "$(dirname "$out")"

      models_json="$(${curl}/bin/curl -fsS "$endpoint/models" \
        | ${jq}/bin/jq '[.data[] | {id: .id} | if (.id | test("gpt-?5\\.5"; "i")) then . + {contextWindow: 272000} else . end]')"

      tmp="$(mktemp)"
      ${jq}/bin/jq -n \
        --arg baseUrl "$endpoint" \
        --argjson models "$models_json" \
        '{
          providers: {
            proxy: {
              baseUrl: $baseUrl,
              api: "openai-completions",
              apiKey: "dummy",
              models: $models
            }
          }
        }' > "$tmp"

      mv "$tmp" "$out"
      echo "Wrote $out with $(${jq}/bin/jq '.providers.proxy.models | length' "$out") models."
    '')
  ];


  programs.pi-coding-agent = {
    enable = true;
    settings = {
      theme = "dark";
      defaultProvider = "proxy";
      defaultModel = "cx/gpt-5.5-medium";
      defaultThinkingLevel = "medium";
      warnings.anthropicExtraUsage = false;
    };
    models = null;
    subagents.settings = {
      agentOverrides = {
        reviewer = {
          thinking = "high";
          inheritProjectContext = false;
        };
        oracle = {
          thinking = "high";
        };
      };
    };
  };

  programs.git = {
    lfs.enable = true;
    settings.push.autoSetupRemote = true;
  };

  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    matchBlocks."*".extraOptions = {
      IdentityAgent = "~/.1password/agent.sock";
    };
  };
}

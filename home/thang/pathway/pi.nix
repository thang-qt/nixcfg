{ ... }: {
  programs.pi-coding-agent = {
    enable = true;
    settings = {
      theme = "dark";
      defaultProvider = "openai-codex";
      defaultModel = "gpt-5.6-terra";
      defaultThinkingLevel = "high";
      warnings.anthropicExtraUsage = false;
      retry.provider.maxRetries = 0;
    };
    models = null;
    multiAccount.settings = {
      includeCursor = false;
      includeQwen = false;
      includeOllama = false;
      showUsage = false;
      providerOrder = [ "openai-codex" ];
      rescueUnmanagedProviders = false;
    };
    subagents.settings = {
      agentOverrides = {
        reviewer = {
          thinking = "high";
          inheritProjectContext = false;
        };
        scout.thinking = "medium";
        oracle = {
          model = "gpt-5.6-sol";
          thinking = "high";
        };
      };
    };
  };
}

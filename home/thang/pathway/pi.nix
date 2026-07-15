{ ... }: {
  programs.pi-coding-agent = {
    enable = true;
    settings = {
      theme = "dark";
      defaultProvider = "proxy";
      defaultModel = "gpt-5.6-luna";
      defaultThinkingLevel = "medium";
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
        scout = {
          model = "deepseek/deepseek-v4-flash";
          thinking = "medium";
        };
        worker = {
          model = "deepseek/deepseek-v4-flash";
        };
        oracle = {
          model = "gpt-5.6-luna";
          thinking = "high";
          fallbackModels = [ "deepseek/deepseek-v4-pro" ];
        };
      };
    };
  };
}

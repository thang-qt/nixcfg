_: {
  programs.pi-coding-agent = {
    enable = true;
    settings = {
      theme = "dark";
      defaultProvider = "openai-codex";
      defaultModel = "gpt-5.6-luna";
      defaultThinkingLevel = "xhigh";
      warnings.anthropicExtraUsage = false;
      retry.provider.maxRetries = 0;
    };
    models = null;
    subagents.settings = {
      agentOverrides = {
        reviewer = {
          model = "gpt-5.6-sol";
          thinking = "high";
          inheritProjectContext = false;
        };
        scout = {
          model = "gpt-5.6-luna";
          thinking = "high";
        };
        worker = {
          model = "gpt-5.6-luna";
          thinking = "high";
        };
        researcher = {
          model = "gpt-5.6-sol";
          thinking = "high";
        };
        oracle = {
          model = "gpt-5.6-sol";
          thinking = "xhigh";
        };
      };
    };
  };
}

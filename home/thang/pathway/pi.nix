{...}: {
  programs.pi-coding-agent = {
    enable = true;
    settings = {
      theme = "dark";
      defaultProvider = "proxy";
      defaultModel = "gpt-5.5";
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
        scout = {
          model = "deepseek/deepseek-v4-flash";
          thinking = "medium";
        };
        worker = {
          model = "deepseek/deepseek-v4-flash";
        };
        oracle = {
          model = "gpt-5.5";
          thinking = "high";
          fallbackModels = ["deepseek/deepseek-v4-pro"];
        };
      };
    };
  };
}

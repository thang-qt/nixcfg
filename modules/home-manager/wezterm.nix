{ pkgs, ... }:
{
  programs.wezterm = {
    enable = true;

    extraConfig = ''
      local wezterm = require 'wezterm'
      local act = wezterm.action

      local config = {}
      if wezterm.config_builder then
        config = wezterm.config_builder()
      end

      config.color_scheme = "Catppuccin Mocha"

      config.initial_rows = 30
      config.initial_cols = 110

      config.hide_tab_bar_if_only_one_tab = true

      config.leader = { key = "Space", mods = "CTRL", timeout_milliseconds = 1000 }

      config.keys = {
        -- Tabs
        { key = "c", mods = "LEADER", action = act.SpawnTab("CurrentPaneDomain") },
        { key = "w", mods = "LEADER", action = act.CloseCurrentTab({ confirm = true }) },
        { key = "n", mods = "LEADER", action = act.ActivateTabRelative(1) },
        { key = "p", mods = "LEADER", action = act.ActivateTabRelative(-1) },

        { key = "1", mods = "LEADER", action = act.ActivateTab(0) },
        { key = "2", mods = "LEADER", action = act.ActivateTab(1) },
        { key = "3", mods = "LEADER", action = act.ActivateTab(2) },
        { key = "4", mods = "LEADER", action = act.ActivateTab(3) },
        { key = "5", mods = "LEADER", action = act.ActivateTab(4) },
        { key = "6", mods = "LEADER", action = act.ActivateTab(5) },
        { key = "7", mods = "LEADER", action = act.ActivateTab(6) },
        { key = "8", mods = "LEADER", action = act.ActivateTab(7) },
        { key = "9", mods = "LEADER", action = act.ActivateTab(8) },

        -- Splits
        { key = "\\", mods = "LEADER", action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
        { key = "-", mods = "LEADER",       action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },

        -- Pane navigation
        { key = "h", mods = "LEADER", action = act.ActivatePaneDirection("Left") },
        { key = "j", mods = "LEADER", action = act.ActivatePaneDirection("Down") },
        { key = "k", mods = "LEADER", action = act.ActivatePaneDirection("Up") },
        { key = "l", mods = "LEADER", action = act.ActivatePaneDirection("Right") },

        { key = "q", mods = "LEADER", action = act.CloseCurrentPane({ confirm = true }) },

        -- Reload
        { key = "r", mods = "LEADER", action = act.ReloadConfiguration },
      }

      return config
    '';
  };
}

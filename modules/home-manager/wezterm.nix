_: {
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

      config.font = wezterm.font("Iosevka Nerd Font Mono")
      config.font_size = 14.0

      config.window_padding = {
        left = 8,
        right = 8,
        top = 8,
        bottom = 8,
      }

      config.initial_rows = 28
      config.initial_cols = 110

      -- Window decorations: keep native OS window controls (titlebar with minimize, maximize, close)
      config.window_decorations = "TITLE | RESIZE"

      -- Custom tab bar at bottom: flat rectangular tabs
      config.use_fancy_tab_bar = false
      config.tab_bar_at_bottom = true
      config.show_new_tab_button_in_tab_bar = false
      config.tab_max_width = 24
      config.hide_tab_bar_if_only_one_tab = true

      config.colors = {
        tab_bar = {
          background = "#11111b", -- crust (distinct from terminal background #1e1e2e)
          active_tab = {
            bg_color = "#313244", -- surface0
            fg_color = "#89b4fa", -- blue accent
            intensity = "Bold",
          },
          inactive_tab = {
            bg_color = "#181825", -- mantle (distinct from terminal background)
            fg_color = "#6c7086", -- overlay0
          },
          inactive_tab_hover = {
            bg_color = "#313244", -- surface0
            fg_color = "#cdd6f4", -- text
          },
          new_tab = {
            bg_color = "#181825",
            fg_color = "#6c7086",
          },
          new_tab_hover = {
            bg_color = "#313244",
            fg_color = "#cdd6f4",
          },
        },
      }

      local function get_tab_title(tab)
        if tab.tab_title and #tab.tab_title > 0 then
          return tab.tab_title
        end
        local pane = tab.active_pane
        if pane.foreground_process_name and #pane.foreground_process_name > 0 then
          local name = pane.foreground_process_name:match("([^/]+)$") or pane.foreground_process_name
          return name
        end
        local title = pane.title or ""
        return title:match("([^/]+)$") or title
      end

      wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
        local background = "#181825"
        local foreground = "#6c7086"

        if tab.is_active then
          background = "#313244"
          foreground = "#89b4fa"
        elseif hover then
          background = "#313244"
          foreground = "#cdd6f4"
        end

        local title = get_tab_title(tab)
        title = wezterm.truncate_right(title, 14)

        return {
          { Background = { Color = background } },
          { Foreground = { Color = foreground } },
          { Attribute = { Intensity = tab.is_active and "Bold" or "Normal" } },
          { Text = "  " .. (tab.tab_index + 1) .. ": " .. title .. "  " },
        }
      end)

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

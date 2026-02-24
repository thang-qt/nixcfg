{ ... }:
{
  programs.zathura = {
    enable = true;
    options = {
      # Notifications
      notification-error-bg = "#eee8d5";
      notification-error-fg = "#dc322f";
      notification-warning-bg = "#eee8d5";
      notification-warning-fg = "#dc322f";
      notification-bg = "#eee8d5";
      notification-fg = "#268bd2";

      # Completion
      completion-bg = "#fdf6e3";
      completion-fg = "#657b83";
      completion-group-bg = "#eee8d5";
      completion-group-fg = "#586e75";
      completion-highlight-bg = "#93a1a1";
      completion-highlight-fg = "#073642";

      # Index mode
      index-bg = "#fdf6e3";
      index-fg = "#657b83";
      index-active-bg = "#eee8d5";
      index-active-fg = "#586e75";

      # Input bar
      inputbar-bg = "#93a1a1";
      inputbar-fg = "#073642";

      # Status bar
      statusbar-bg = "#fdf6e3";
      statusbar-fg = "#657b83";

      # Highlight
      highlight-color = "#839496";
      highlight-active-color = "#cb4616";

      # Default colors
      default-bg = "#fdf6e3";
      default-fg = "#657b83";
      render-loading = true;

      # Recolor book content
      recolor-lightcolor = "#fdf6e3";
      recolor-darkcolor = "#441100";
      recolor = true;
      recolor-keephue = true;

      # Clipboard
      selection-clipboard = "clipboard";
    };
  };
}

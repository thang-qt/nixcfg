{pkgs, ...}: {
  programs.zellij = {
    enable = true;
    package = pkgs.unstable.zellij;

    # Keep the UI deliberately quiet: one compact bar and no pane borders.
    extraConfig = ''
      simplified_ui true
      pane_frames false
      mouse_mode true
      mouse_hover_effects false
      mouse_hover_tips false
      default_layout "custom"
      default_mode "locked"
      theme "catppuccin-mocha"
      default_shell "fish"
      show_startup_tips false

      // Unlock-first keeps terminal applications' Ctrl shortcuts intact.
      // Ctrl-g is the mode prefix; only Alt-h/j/k/l and Alt-1..9 are reserved
      // for low-collision quick focus and tab switching while locked.
      keybinds clear-defaults=true {
          normal {
              // Fast paths after Ctrl-g for the operations used most often.
              bind "h" "Left" { MoveFocusOrTab "Left"; SwitchToMode "Locked"; }
              bind "j" "Down" { MoveFocusOrTab "Down"; SwitchToMode "Locked"; }
              bind "k" "Up" { MoveFocusOrTab "Up"; SwitchToMode "Locked"; }
              bind "l" "Right" { MoveFocusOrTab "Right"; SwitchToMode "Locked"; }
              bind "n" { NewPane; SwitchToMode "Locked"; }
              bind "f" { ToggleFloatingPanes; SwitchToMode "Locked"; }
              bind "x" { CloseFocus; SwitchToMode "Locked"; }
              // Toggle Zellij's zen mode: hide both bars and fill the display.
              bind "z" { ToggleFocusNoUiFullscreen; SwitchToMode "Locked"; }
              bind "[" { GoToPreviousTab; SwitchToMode "Locked"; }
              bind "]" { GoToNextTab; SwitchToMode "Locked"; }

              // Mode entry: Ctrl-g followed by a mnemonic key.
              bind "p" { SwitchToMode "Pane"; }
              bind "r" { SwitchToMode "Resize"; }
              bind "s" { SwitchToMode "Scroll"; }
              bind "o" { SwitchToMode "Session"; }
              bind "t" { SwitchToMode "Tab"; }
              bind "m" { SwitchToMode "Move"; }
          }

          locked {
              bind "Ctrl g" { SwitchToMode "Normal"; }
          }

          resize {
              bind "r" { SwitchToMode "Locked"; }
              bind "h" "Left" { Resize "Increase Left"; }
              bind "j" "Down" { Resize "Increase Down"; }
              bind "k" "Up" { Resize "Increase Up"; }
              bind "l" "Right" { Resize "Increase Right"; }
              bind "H" { Resize "Decrease Left"; }
              bind "J" { Resize "Decrease Down"; }
              bind "K" { Resize "Decrease Up"; }
              bind "L" { Resize "Decrease Right"; }
              bind "=" "+" { Resize "Increase"; }
              bind "-" { Resize "Decrease"; }
          }

          pane {
              bind "p" { SwitchFocus; }
              bind "Tab" { SwitchFocus; }
              bind "h" "Left" { MoveFocus "Left"; }
              bind "l" "Right" { MoveFocus "Right"; }
              bind "j" "Down" { MoveFocus "Down"; }
              bind "k" "Up" { MoveFocus "Up"; }
              bind "n" { NewPane; SwitchToMode "Locked"; }
              bind "d" { NewPane "Down"; SwitchToMode "Locked"; }
              bind "r" { NewPane "Right"; SwitchToMode "Locked"; }
              bind "s" { NewPane "stacked"; SwitchToMode "Locked"; }
              bind "x" { CloseFocus; SwitchToMode "Locked"; }
              bind "f" { ToggleFocusFullscreen; SwitchToMode "Locked"; }
              bind "z" { TogglePaneFrames; SwitchToMode "Locked"; }
              bind "w" { ToggleFloatingPanes; SwitchToMode "Locked"; }
              bind "e" { TogglePaneEmbedOrFloating; SwitchToMode "Locked"; }
              bind "c" { SwitchToMode "RenamePane"; PaneNameInput 0; }
              bind "i" { TogglePanePinned; SwitchToMode "Locked"; }
          }

          move {
              bind "m" { SwitchToMode "Locked"; }
              bind "n" "Tab" { MovePane; }
              bind "p" { MovePaneBackwards; }
              bind "h" "Left" { MovePane "Left"; }
              bind "j" "Down" { MovePane "Down"; }
              bind "k" "Up" { MovePane "Up"; }
              bind "l" "Right" { MovePane "Right"; }
          }

          tab {
              bind "t" { SwitchToMode "Locked"; }
              bind "r" { SwitchToMode "RenameTab"; TabNameInput 0; }
              bind "h" "Left" "Up" "k" { GoToPreviousTab; }
              bind "l" "Right" "Down" "j" { GoToNextTab; }
              bind "n" { NewTab; SwitchToMode "Locked"; }
              bind "x" { CloseTab; SwitchToMode "Locked"; }
              bind "s" { ToggleActiveSyncTab; SwitchToMode "Locked"; }
              bind "b" { BreakPane; SwitchToMode "Locked"; }
              bind "]" { BreakPaneRight; SwitchToMode "Locked"; }
              bind "[" { BreakPaneLeft; SwitchToMode "Locked"; }
              bind "1" { GoToTab 1; SwitchToMode "Locked"; }
              bind "2" { GoToTab 2; SwitchToMode "Locked"; }
              bind "3" { GoToTab 3; SwitchToMode "Locked"; }
              bind "4" { GoToTab 4; SwitchToMode "Locked"; }
              bind "5" { GoToTab 5; SwitchToMode "Locked"; }
              bind "6" { GoToTab 6; SwitchToMode "Locked"; }
              bind "7" { GoToTab 7; SwitchToMode "Locked"; }
              bind "8" { GoToTab 8; SwitchToMode "Locked"; }
              bind "9" { GoToTab 9; SwitchToMode "Locked"; }
              bind "Tab" { ToggleTab; }
          }

          scroll {
              bind "s" { SwitchToMode "Locked"; }
              bind "e" { EditScrollback; SwitchToMode "Locked"; }
              bind "f" { SwitchToMode "EnterSearch"; SearchInput 0; }
              bind "Ctrl c" { ScrollToBottom; SwitchToMode "Locked"; }
              bind "j" "Down" { ScrollDown; }
              bind "k" "Up" { ScrollUp; }
              bind "Ctrl f" "PageDown" "Right" "l" { PageScrollDown; }
              bind "Ctrl b" "PageUp" "Left" "h" { PageScrollUp; }
              bind "d" { HalfPageScrollDown; }
              bind "u" { HalfPageScrollUp; }
          }

          search {
              bind "Ctrl s" { SwitchToMode "Locked"; }
              bind "Ctrl c" { ScrollToBottom; SwitchToMode "Locked"; }
              bind "j" "Down" { ScrollDown; }
              bind "k" "Up" { ScrollUp; }
              bind "Ctrl f" "PageDown" "Right" "l" { PageScrollDown; }
              bind "Ctrl b" "PageUp" "Left" "h" { PageScrollUp; }
              bind "d" { HalfPageScrollDown; }
              bind "u" { HalfPageScrollUp; }
              bind "n" { Search "down"; }
              bind "p" { Search "up"; }
              bind "c" { SearchToggleOption "CaseSensitivity"; }
              bind "w" { SearchToggleOption "Wrap"; }
              bind "o" { SearchToggleOption "WholeWord"; }
          }

          entersearch {
              bind "Ctrl c" "Esc" { SwitchToMode "Scroll"; }
              bind "Enter" { SwitchToMode "Search"; }
          }

          renametab {
              bind "Ctrl c" "Enter" { SwitchToMode "Locked"; }
              bind "Esc" { UndoRenameTab; SwitchToMode "Locked"; }
          }

          renamepane {
              bind "Ctrl c" "Enter" { SwitchToMode "Locked"; }
              bind "Esc" { UndoRenamePane; SwitchToMode "Locked"; }
          }

          session {
              bind "o" { SwitchToMode "Locked"; }
              bind "d" { Detach; }
              bind "w" {
                  LaunchOrFocusPlugin "session-manager" {
                      floating true
                      move_to_focused_tab true
                  };
                  SwitchToMode "Locked"
              }
              bind "c" {
                  LaunchOrFocusPlugin "configuration" {
                      floating true
                      move_to_focused_tab true
                  };
                  SwitchToMode "Locked"
              }
              bind "p" {
                  LaunchOrFocusPlugin "plugin-manager" {
                      floating true
                      move_to_focused_tab true
                  };
                  SwitchToMode "Locked"
              }
          }

          // These bindings are active only after Ctrl-g, never while locked.
          shared_except "locked" "renametab" "renamepane" {
              bind "Ctrl g" { SwitchToMode "Locked"; }
              bind "Ctrl q" { Quit; }
          }

          shared_except "renamepane" "renametab" "entersearch" "locked" {
              bind "Esc" { SwitchToMode "Locked"; }
          }

          shared_except "locked" "renametab" "renamepane" {
              bind "Enter" { SwitchToMode "Locked"; }
          }

          // Low-collision quick focus and tab controls remain available while locked.
          shared_among "normal" "locked" {
              bind "Alt h" { MoveFocusOrTab "Left"; SwitchToMode "Locked"; }
              bind "Alt j" { MoveFocusOrTab "Down"; SwitchToMode "Locked"; }
              bind "Alt k" { MoveFocusOrTab "Up"; SwitchToMode "Locked"; }
              bind "Alt l" { MoveFocusOrTab "Right"; SwitchToMode "Locked"; }
              bind "Alt 1" { GoToTab 1; SwitchToMode "Locked"; }
              bind "Alt 2" { GoToTab 2; SwitchToMode "Locked"; }
              bind "Alt 3" { GoToTab 3; SwitchToMode "Locked"; }
              bind "Alt 4" { GoToTab 4; SwitchToMode "Locked"; }
              bind "Alt 5" { GoToTab 5; SwitchToMode "Locked"; }
              bind "Alt 6" { GoToTab 6; SwitchToMode "Locked"; }
              bind "Alt 7" { GoToTab 7; SwitchToMode "Locked"; }
              bind "Alt 8" { GoToTab 8; SwitchToMode "Locked"; }
              bind "Alt 9" { GoToTab 9; SwitchToMode "Locked"; }
          }
      }
    '';

    # Custom layout with the compact-bar plugin.
    layouts = {
      custom = ''
        layout {
            pane size=1 borderless=true {
                plugin location="compact-bar"
            }
            pane
        }
      '';
    };
  };
}

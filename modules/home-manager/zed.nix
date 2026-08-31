{
  lib,
  pkgs,
  ...
}: {
  programs.zed-editor = {
    enable = true;
    package = pkgs.unstable.zed-editor;
    installRemoteServer = true;

    extensions = [
      "catppuccin"
      "nix"
      "toml"
      "make"
      "html"
      "scss"
      "tailwind-theme"
      "graphql"
      "dockerfile"
      "docker-compose"
      "gotmpl"
      "go-snippets"
    ];

    extraPackages = with pkgs; [
      nodejs
      typescript-language-server
      vscode-langservers-extracted
      tailwindcss-language-server
      prettierd
      eslint_d
      nixd
      alejandra
      nil
      gopls
      gofumpt
      golangci-lint-langserver
      delve
      bash-language-server
      shellcheck
      shfmt
      yaml-language-server
    ];

    userSettings = {
      auto_update = false;
      telemetry = {
        diagnostics = false;
        metrics = false;
      };

      base_keymap = "VSCode";
      helix_mode = true;
      load_direnv = "shell_hook";
      restore_on_startup = "last_workspace";
      confirm_quit = false;

      theme = {
        mode = "dark";
        light = "Catppuccin Mocha";
        dark = "Catppuccin Mocha";
      };

      ui_font_family = "Iosevka Nerd Font";
      buffer_font_family = "Iosevka Nerd Font Mono";
      ui_font_size = 15;
      buffer_font_size = 15;
      buffer_line_height = "comfortable";
      show_whitespaces = "selection";
      soft_wrap = "editor_width";
      preferred_line_length = 100;
      ensure_final_newline_on_save = true;
      remove_trailing_whitespace_on_save = true;
      format_on_save = "on";
      autosave = {
        after_delay = {
          milliseconds = 1000;
        };
      };

      project_panel = {
        dock = "left";
        git_status = true;
        auto_fold_dirs = false;
        auto_reveal_entries = true;
        indent_size = 12;
        button = true;
      };

      git = {
        inline_blame = {
          enabled = false;
        };
      };

      terminal = {
        dock = "bottom";
        shell = "system";
        working_directory = "current_project_directory";
        alternate_scroll = "off";
        blinking = "off";
        copy_on_select = false;
        detect_venv = {
          on = {
            directories = [".env" "env" ".venv" "venv"];
            activate_script = "default";
          };
        };
        env = {
          TERM = "alacritty";
        };
        font_family = "Iosevka Nerd Font Mono";
        line_height = "comfortable";
      };

      node = {
        path = lib.getExe pkgs.nodejs;
        npm_path = lib.getExe' pkgs.nodejs "npm";
      };

      languages = {
        Nix = {
          language_servers = ["nixd" "!nil"];
          formatter = {
            external = {
              command = lib.getExe pkgs.alejandra;
            };
          };
        };
        Go = {
          language_servers = ["gopls"];
          formatter = {
            external = {
              command = lib.getExe pkgs.gofumpt;
            };
          };
        };
        JavaScript = {
          language_servers = ["typescript-language-server" "eslint"];
        };
        TypeScript = {
          language_servers = ["typescript-language-server" "eslint"];
        };
        HTML = {
          language_servers = ["vscode-html-language-server" "tailwindcss-language-server"];
        };
        CSS = {
          language_servers = ["vscode-css-language-server" "tailwindcss-language-server"];
        };
        Markdown = {
          format_on_save = "off";
        };
      };
    };
  };
}

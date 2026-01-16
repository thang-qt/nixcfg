{
  pkgs,
  ...
}:
{
  programs.helix = {
    enable = true;
    themes = {
      mocha_transparent = {
        inherits = "catppuccin_mocha";
        "ui.background" = { };
      };
    };
    settings = {
      theme = "catppuccin_mocha";
      editor = {
        line-number = "relative";
        color-modes = true;
        true-color = true;
        cursorline = true;
        bufferline = "multiple";
        cursor-shape = {
          insert = "bar";
          normal = "block";
          select = "underline";
        };
        indent-guides.render = true;
        gutters.line-numbers.min-width = 1;
        statusline = {
          left = [
            "mode"
            "file-name"
            "spinner"
          ];
          center = [ "diagnostics" ];
          right = [
            "version-control"
            "position"
            "file-encoding"
          ];
          separator = "|";
          mode = {
            normal = "NORMAL";
            insert = "INSERT";
            select = "SELECT";
          };
        };
      };
      keys.normal.D = "kill_to_line_end";
    };
    languages = {
      language-server = {
        cpp-lsp.command = "${pkgs.clang-tools}/bin/clangd";
        nix-lsp.command = "${pkgs.nil}/bin/nil";
      };
      language = [
        {
          name = "nix";
          auto-format = true;
          formatter.command = "${pkgs.nixfmt-rfc-style}/bin/nixfmt";
          language-servers = [ "nix-lsp" ];
        }
        {
          name = "cpp";
          auto-format = true;
          formatter.command = "${pkgs.clang-tools}/bin/clang-format";
          language-servers = [ "cpp-lsp" ];
        }
      ];
    };
  };
}

{pkgs, ...}: {
  programs.yazi = {
    enable = true;
    enableFishIntegration = true;
    shellWrapperName = "y";

    extraPackages = with pkgs; [
      file
      fd
      ripgrep
      fzf
      zoxide
      jq
      poppler
      ffmpegthumbnailer
      resvg
      imagemagick
      unar
      unzip
      p7zip
      xdg-utils
    ];

    flavors.catppuccin-mocha =
      pkgs.fetchFromGitHub {
        owner = "yazi-rs";
        repo = "flavors";
        rev = "main";
        hash = "sha256-erZI0H5TxqFu2P917juL5PIB3LC0oJGKPcB1VibJDqo=";
      }
      + "/catppuccin-mocha.yazi";

    theme.flavor = {
      dark = "catppuccin-mocha";
      light = "catppuccin-mocha";
    };

    settings = {
      mgr = {
        ratio = [1 3 4];
        sort_by = "natural";
        sort_sensitive = false;
        sort_reverse = false;
        sort_dir_first = true;
        linemode = "size";
        show_hidden = false;
        show_symlink = true;
        scrolloff = 8;
      };

      preview = {
        tab_size = 2;
        max_width = 1600;
        max_height = 1600;
        cache_dir = "~/.cache/yazi";
      };

      opener = {
        edit = [
          {
            run = ''hx "$@"'';
            block = true;
            for = "unix";
          }
        ];
        open = [
          {
            run = ''xdg-open "$1"'';
            desc = "Open";
            for = "linux";
          }
        ];
        reveal = [
          {
            run = ''xdg-open "$(dirname "$1")"'';
            desc = "Reveal";
            for = "linux";
          }
        ];
      };

      open.rules = [
        {
          mime = "text/*";
          use = "edit";
        }
        {
          mime = "application/json";
          use = "edit";
        }
        {
          mime = "application/javascript";
          use = "edit";
        }
        {
          mime = "inode/directory";
          use = "open";
        }
        {
          mime = "image/*";
          use = "open";
        }
        {
          mime = "video/*";
          use = "open";
        }
        {
          mime = "audio/*";
          use = "open";
        }
        {
          mime = "application/pdf";
          use = "open";
        }
        {
          url = "*";
          use = "open";
        }
      ];
    };
  };
}

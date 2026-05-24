{ pkgs, ... }:
let
  everforestLotusFlavor = pkgs.writeTextDir "flavor.toml" ''
    # Local Everforest fork of the Kanagawa Lotus Yazi flavor layout.
    # Source inspiration: muratoffalex/kanagawa-lotus.yazi
    # Everforest dark palette:
    # bg0 #2b3339, bg1 #323c41, bg2 #3a454a, bg3 #445055
    # fg #d3c6aa, grey #859289, red #e67e80, orange #e69875
    # yellow #dbbc7f, green #a7c080, aqua #83c092, blue #7fbbb3, purple #d699b6

    [mgr]
    marker_copied = { fg = "#a7c080", bg = "#a7c080" }
    marker_cut = { fg = "#e67e80", bg = "#e67e80" }
    marker_marked = { fg = "#d699b6", bg = "#d699b6" }
    marker_selected = { fg = "#e69875", bg = "#e69875" }
    cwd = { fg = "#dbbc7f" }
    hovered = { fg = "#2b3339", bg = "#a7c080" }
    preview_hovered = { fg = "#2b3339", bg = "#a7c080" }
    find_keyword = { fg = "#e69875", bg = "#323c41" }
    find_position = { fg = "#d699b6", bg = "#323c41" }
    count_copied = { fg = "#2b3339", bg = "#a7c080" }
    count_cut = { fg = "#2b3339", bg = "#e67e80" }
    count_selected = { fg = "#2b3339", bg = "#dbbc7f" }
    border_symbol = "│"
    border_style = { fg = "#859289" }

    [tabs]
    active = { fg = "#2b3339", bg = "#a7c080" }
    inactive = { fg = "#859289", bg = "#323c41" }
    sep_inner = { open = "", close = "" }
    sep_outer = { open = "", close = "" }

    [mode]
    normal_main = { fg = "#2b3339", bg = "#a7c080" }
    normal_alt = { fg = "#a7c080", bg = "#323c41" }
    select_main = { fg = "#2b3339", bg = "#d699b6" }
    select_alt = { fg = "#d699b6", bg = "#323c41" }
    unset_main = { fg = "#2b3339", bg = "#dbbc7f" }
    unset_alt = { fg = "#dbbc7f", bg = "#323c41" }

    [status]
    sep_left = { open = "", close = "" }
    sep_right = { open = "", close = "" }
    overall = { fg = "#d3c6aa", bg = "#2b3339" }
    progress_label = { fg = "#7fbbb3", bg = "#323c41", bold = true }
    progress_normal = { fg = "#a7c080", bg = "#3a454a" }
    progress_error = { fg = "#e67e80", bg = "#3a454a" }
    perm_type = { fg = "#a7c080" }
    perm_read = { fg = "#dbbc7f" }
    perm_write = { fg = "#e67e80" }
    perm_exec = { fg = "#83c092" }
    perm_sep = { fg = "#859289" }

    [which]
    cols = 2
    separator = " - "
    separator_style = { fg = "#859289" }
    mask = { bg = "#2b3339" }
    rest = { fg = "#859289" }
    cand = { fg = "#7fbbb3" }
    desc = { fg = "#d699b6" }

    [pick]
    border = { fg = "#7fbbb3" }
    active = { fg = "#d699b6", bold = true }
    inactive = { fg = "#859289" }

    [input]
    border = { fg = "#7fbbb3" }
    title = { fg = "#a7c080" }
    value = { fg = "#d3c6aa" }
    selected = { reversed = true }

    [cmp]
    border = { fg = "#7fbbb3" }
    active = { fg = "#2b3339", bg = "#a7c080" }
    inactive = { fg = "#859289" }

    [tasks]
    border = { fg = "#7fbbb3" }
    title = { fg = "#a7c080" }
    hovered = { fg = "#d699b6" }

    [help]
    on = { fg = "#83c092" }
    run = { fg = "#d699b6" }
    desc = { fg = "#d3c6aa" }
    hovered = { reversed = true, bold = true }
    footer = { fg = "#d3c6aa", bg = "#323c41" }

    [notify]
    title_info = { fg = "#a7c080" }
    title_warn = { fg = "#dbbc7f" }
    title_error = { fg = "#e67e80" }

    [filetype]
    rules = [
      { mime = "image/*", fg = "#dbbc7f" },
      { mime = "{audio,video}/*", fg = "#d699b6" },
      { mime = "application/{zip,rar,7z*,tar,gzip,xz,zstd,bzip*,lzma,compress,archive,cpio,arj,xar,ms-cab*}", fg = "#e67e80" },
      { mime = "application/{pdf,doc,rtf,vnd.*}", fg = "#83c092" },
      { url = "*", is = "orphan", fg = "#e67e80" },
      { url = "*", is = "exec", fg = "#a7c080" },
      { url = "*", fg = "#d3c6aa" },
      { url = "*/", fg = "#7fbbb3" },
    ]

    [icon]
    dirs = [
      { name = ".config", text = "", fg = "#d699b6" },
      { name = ".git", text = "", fg = "#dbbc7f" },
      { name = ".github", text = "", fg = "#7fbbb3" },
      { name = ".npm", text = "", fg = "#e67e80" },
      { name = "Desktop", text = "", fg = "#dbbc7f" },
      { name = "Dev", text = "󰲋", fg = "#859289" },
      { name = "Documents", text = "", fg = "#dbbc7f" },
      { name = "Downloads", text = "", fg = "#dbbc7f" },
      { name = "Library", text = "", fg = "#dbbc7f" },
      { name = "Movies", text = "", fg = "#d699b6" },
      { name = "Music", text = "", fg = "#d699b6" },
      { name = "Pictures", text = "", fg = "#dbbc7f" },
      { name = "Public", text = "", fg = "#dbbc7f" },
      { name = "Videos", text = "", fg = "#d699b6" },
    ]
    conds = [
      { if = "orphan", text = "", fg = "#e67e80" },
      { if = "link", text = "", fg = "#859289" },
      { if = "block", text = "", fg = "#dbbc7f" },
      { if = "char", text = "", fg = "#dbbc7f" },
      { if = "fifo", text = "", fg = "#dbbc7f" },
      { if = "sock", text = "", fg = "#dbbc7f" },
      { if = "sticky", text = "", fg = "#dbbc7f" },
      { if = "dummy", text = "", fg = "#e67e80" },
      { if = "dir", text = "", fg = "#7fbbb3" },
      { if = "exec", text = "", fg = "#a7c080" },
      { if = "!dir", text = "", fg = "#d3c6aa" },
    ]
  '';
in
{
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

    flavors.everforest-lotus = everforestLotusFlavor;

    theme.flavor = {
      dark = "everforest-lotus";
      light = "everforest-lotus";
    };

    settings = {
      mgr = {
        ratio = [ 1 3 4 ];
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
          { run = ''hx "$@"''; block = true; for = "unix"; }
        ];
        open = [
          { run = ''xdg-open "$1"''; desc = "Open"; for = "linux"; }
        ];
        reveal = [
          { run = ''xdg-open "$(dirname "$1")"''; desc = "Reveal"; for = "linux"; }
        ];
      };

      open.rules = [
        { mime = "text/*"; use = "edit"; }
        { mime = "application/json"; use = "edit"; }
        { mime = "application/javascript"; use = "edit"; }
        { mime = "inode/directory"; use = "open"; }
        { mime = "image/*"; use = "open"; }
        { mime = "video/*"; use = "open"; }
        { mime = "audio/*"; use = "open"; }
        { mime = "application/pdf"; use = "open"; }
        { name = "*"; use = "open"; }
      ];
    };
  };
}

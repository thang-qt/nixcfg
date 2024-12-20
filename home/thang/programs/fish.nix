{ config, pkgs, ... }:
{
  programs.fish = {
    enable = true;
    interactiveShellInit = "
      set fish_greeting; 
      nix-your-shell fish | source; 
      zoxide init fish | source
      set fzf_directory_opts --bind \"alt-o:execute($EDITOR {} &> /dev/tty)\"
    ";
    catppuccin.enable = true;
    functions = {
      mkcd = {
        body = ''
          mkdir -p $argv[1]; and cd $argv[1]
        '';
      };
    };
    plugins = [
      {
        name = "tide";
        src = pkgs.fishPlugins.tide.src;
      }
      {
        name = "fzf.fish";
        src = pkgs.fishPlugins.fzf-fish.src;
      }
      {
        name = "plugin-git";
        src = pkgs.fishPlugins.plugin-git.src;
      }
      {
        name = "sudope";
        src = pkgs.fishPlugins.plugin-sudope.src;
      }
      {
        name = "bd";
        src = pkgs.fishPlugins.fish-bd.src;
      }
    ];
  };
}

{
  config,
  pkgs,
  inputs,
  lib,
  ...
}:
{
  time.timeZone = "Asia/Ho_Chi_Minh";

  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "vi_VN";
    LC_IDENTIFICATION = "vi_VN";
    LC_MEASUREMENT = "vi_VN";
    LC_MONETARY = "vi_VN";
    LC_NAME = "vi_VN";
    LC_NUMERIC = "vi_VN";
    LC_PAPER = "vi_VN";
    LC_TELEPHONE = "vi_VN";
    LC_TIME = "vi_VN";
  };

  nixpkgs = {
    overlays = [
      inputs.self.overlays.additions
      inputs.self.overlays.modifications
      inputs.self.overlays.unstable-packages
    ];
    config = {
      allowUnfree = true;
    };
  };

  nix =
    let
      flakeInputs = lib.filterAttrs (_: lib.isType "flake") inputs;
    in
    {
      settings = {
        experimental-features = "nix-command flakes";
        flake-registry = "";
        nix-path = config.nix.nixPath;
      };
      channel.enable = false;

      registry = lib.mapAttrs (_: flake: { inherit flake; }) flakeInputs;
      nixPath = lib.mapAttrsToList (n: _: "${n}=flake:${n}") flakeInputs;
      gc = {
        automatic = true;
        dates = "monthly";
        options = "--delete-older-than 30d";
      };
      optimise.automatic = true;
    };

  environment.systemPackages = with pkgs; [
    wget
    curl
    git
    helix
    lazygit
    fzf
    fd
    ripgrep
    home-manager
    zoxide
    nix-your-shell
  ];

  programs.fish.enable = true;

  programs.direnv = {
    enable = true;
    silent = true;
  };

  services.tailscale = {
    enable = true;
  };

  users.users.thang = {
    isNormalUser = true;
    description = "Quang Thang";
    initialPassword = "Blackterm222#";
    shell = pkgs.fish;
    extraGroups = [
      "wheel"
    ];
  };
}

{
  description = "ThangQT's Nix config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager.url = "github:nix-community/home-manager/release-26.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";
    git-hooks = {
      url = "github:cachix/git-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    auto-cpufreq = {
      url = "github:AdnanHodzic/auto-cpufreq";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    kairos.url = "github:thang-qt/Kairos/01adc27e043b458c0d4b469e2cfb634611d86891";
    llm-agents.url = "github:numtide/llm-agents.nix";
    hermes-agent.url = "github:NousResearch/hermes-agent";
    zen-browser = {
      url = "github:youwen5/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    helium = {
      url = "github:AlvaroParker/helium-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # Keep Noctalia's own nixpkgs input so its binary cache remains usable.
    noctalia.url = "github:noctalia-dev/noctalia/cachix";
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    auto-cpufreq,
    ...
  } @ inputs: let
    systems = [
      "aarch64-linux"
      "i686-linux"
      "x86_64-linux"
      "aarch64-darwin"
      "x86_64-darwin"
    ];
    forAllSystems = nixpkgs.lib.genAttrs systems;
    preCommitCheckFor = system:
      if builtins.hasAttr system inputs.git-hooks.lib
      then
        inputs.git-hooks.lib.${system}.run {
          src = ./.;
          hooks = {
            alejandra.enable = true;
            deadnix.enable = true;
            statix.enable = true;
          };
        }
      else null;
  in {
    packages = forAllSystems (system: import ./pkgs nixpkgs.legacyPackages.${system});
    formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.alejandra);

    checks = forAllSystems (
      system: let
        pkgs = nixpkgs.legacyPackages.${system};
        preCommitCheck = preCommitCheckFor system;
      in
        {
          formatting =
            pkgs.runCommand "check-nix-formatting" {
              nativeBuildInputs = [pkgs.alejandra];
              src = self;
            } ''
              cp -r "$src" source
              chmod -R u+w source
              alejandra --check source
              touch "$out"
            '';

          lint =
            pkgs.runCommand "lint-nix" {
              nativeBuildInputs = [
                pkgs.deadnix
                pkgs.statix
              ];
              src = self;
            } ''
              cp -r "$src" source
              chmod -R u+w source
              cd source
              statix check .
              deadnix --fail .
              touch "$out"
            '';
        }
        // nixpkgs.lib.optionalAttrs (preCommitCheck != null) {
          pre-commit = preCommitCheck;
        }
    );

    devShells = forAllSystems (
      system: let
        pkgs = nixpkgs.legacyPackages.${system};
        preCommitCheck = preCommitCheckFor system;
      in {
        default = pkgs.mkShell {
          packages =
            (with pkgs; [
              age
              alejandra
              deadnix
              git
              jq
              nixd
              nh
              sops
              ssh-to-age
              statix
            ])
            ++ pkgs.lib.optionals (preCommitCheck != null) preCommitCheck.enabledPackages;
          shellHook = pkgs.lib.optionalString (preCommitCheck != null) preCommitCheck.shellHook;
        };
      }
    );

    overlays = import ./overlays {inherit inputs;};
    nixosModules = import ./modules/nixos;
    homeManagerModules = import ./modules/home-manager;

    nixosConfigurations = {
      nebula = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs;};
        modules = [
          ./nixos/nebula/configuration.nix
        ];
      };
      pathway = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs;};
        modules = [
          ./nixos/pathway/configuration.nix
          auto-cpufreq.nixosModules.default
        ];
      };
      petri = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs;};
        modules = [
          ./nixos/petri/configuration.nix
        ];
      };
    };

    homeConfigurations = {
      "thang@nebula" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.aarch64-linux;
        extraSpecialArgs = {inherit inputs;};
        modules = [
          ./home/thang/nebula/home.nix
        ];
      };
      "thang@pathway" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        extraSpecialArgs = {inherit inputs;};
        modules = [
          ./home/thang/pathway/home.nix
        ];
      };
      "thang@petri" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.aarch64-linux;
        extraSpecialArgs = {inherit inputs;};
        modules = [
          ./home/thang/petri/home.nix
        ];
      };
    };
  };
}

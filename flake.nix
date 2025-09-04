{
  description = "ThangQT's NixOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixos-wsl.url = "github:nix-community/NixOS-WSL/main";
    readn = {
      url = "github:thang-qt/Readn";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    agenix.url = "github:ryantm/agenix";
    quickshell = {
      url = "git+https://git.outfoxxed.me/outfoxxed/quickshell";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      nixpkgs-unstable,
      home-manager,
      readn,
      ...
    }@inputs:
    let
      # Default system set to x86_64-linux
      defaultSystem = "x86_64-linux";
    in
    {
      nixosConfigurations.matrix = nixpkgs-unstable.lib.nixosSystem {
        system = defaultSystem;
        specialArgs = {
          inherit inputs;
        };
        modules = [
          ./modules/common.nix
          ./modules/common_non_server.nix
          ./hosts/matrix/configuration.nix
          inputs.agenix.nixosModules.default
          inputs.spicetify-nix.nixosModules.default
          {
            environment.systemPackages = [
              inputs.agenix.packages.${defaultSystem}.default
            ];
          }
        ];
      };

      nixosConfigurations.leaf = nixpkgs-unstable.lib.nixosSystem {
        system = defaultSystem;
        specialArgs = {
          inherit inputs;
        };
        modules = [
          ./modules/common.nix
          ./modules/common_non_server.nix
          ./hosts/leaf/configuration.nix
          inputs.agenix.nixosModules.default
          inputs.spicetify-nix.nixosModules.default
          {
            environment.systemPackages = [
              inputs.agenix.packages.${defaultSystem}.default
            ];
          }
        ];
      };

      nixosConfigurations.jail = nixpkgs-unstable.lib.nixosSystem {
        system = defaultSystem;
        specialArgs = {
          inherit inputs;
        };
        modules = [
          inputs.nixos-wsl.nixosModules.default
          ./modules/common.nix
          ./hosts/jail/configuration.nix
          inputs.agenix.nixosModules.default
          {
            environment.systemPackages = [
              inputs.agenix.packages.${defaultSystem}.default
            ];
          }
        ];
      };

      nixosConfigurations.satellite = nixpkgs-unstable.lib.nixosSystem {
        system = "aarch64-linux";
        specialArgs = {
          inherit inputs;
        };
        modules = [
          ./modules/common.nix
          ./hosts/satellite/configuration.nix
          inputs.agenix.nixosModules.default
          {
            environment.systemPackages = [
              inputs.agenix.packages."aarch64-linux".default
            ];
          }
        ];
      };

      nixosConfigurations.chalkboard = nixpkgs-unstable.lib.nixosSystem {
        system = "aarch64-linux";
        specialArgs = {
          inherit inputs;
        };
        modules = [
          ./modules/common.nix
          ./hosts/chalkboard/configuration.nix
          inputs.agenix.nixosModules.default
          {
            environment.systemPackages = [
              inputs.agenix.packages."aarch64-linux".default
            ];
          }
        ];
      };

      nixosConfigurations.seed = nixpkgs.lib.nixosSystem {
        system = defaultSystem;
        specialArgs = {
          inherit inputs;
        };
        modules = [
          ./modules/common.nix
          ./hosts/seed/configuration.nix
          inputs.agenix.nixosModules.default
          {
            environment.systemPackages = [
              inputs.agenix.packages.${defaultSystem}.default
            ];
          }
        ];
      };

      homeConfigurations."thang@leaf" = home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs-unstable { system = defaultSystem; };
        extraSpecialArgs = {
          inherit inputs;
        };
        modules = [
          inputs.spicetify-nix.homeManagerModules.default
          ./hosts/leaf/home.nix
        ];
      };

      homeConfigurations."thang@jail" = home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs-unstable { system = defaultSystem; };
        extraSpecialArgs = {
          inherit inputs;
        };
        modules = [
          inputs.spicetify-nix.homeManagerModules.default
          ./hosts/jail/home.nix
        ];
      };
    };
}

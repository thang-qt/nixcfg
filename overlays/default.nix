{inputs, ...}: {
  additions = final: prev:
    import ../pkgs {
      pkgs = final;
      inherit (prev.stdenv.hostPlatform) system;
      inherit inputs;
    };

  modifications = final: prev:
    {
    }
    // (import ./readn.nix final prev);

  unstable-packages = final: _prev: {
    unstable = import inputs.nixpkgs-unstable {
      system = final.stdenv.hostPlatform.system;
      config.allowUnfree = true;
    };
  };
}

{
  description = "linehash (le): Fast, deterministic line editing CLI for LLMs";

  nixConfig = {
    extra-substituters = [
      "https://cache.nixos.org"
      "https://nix-community.cachix.org"
      "https://rogernavelsaker.cachix.org"
      "https://nacosolutions.cachix.org"
    ];
    extra-trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "rogernavelsaker.cachix.org-1:n1DtzMNhA9Rz4Kg3xlXOi/KceULu8VrMbs9WXyMFQNQ="
      "nacosolutions.cachix.org-1:JzCiW2CLcuLXtwOVAg3SlSK/kpqWbfSFEVenyKVUlug="
    ];
  };


  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    linehash-src = {
      url = "github:RogerNavelsaker/linehash";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, flake-utils, linehash-src }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        linehash = pkgs.rustPlatform.buildRustPackage {
          pname = "linehash";
          version = "0.1.0-5a8e314";
          src = linehash-src;
          cargoLock = {
            lockFile = "${linehash-src}/Cargo.lock";
            allowBuiltinFetchGit = true;
          };
        };
      in
      {
        packages.default = linehash;
        packages.linehash = linehash;
        packages.le = linehash;

        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [ cargo rustc rustfmt clippy ];
        };
      }
    );
}
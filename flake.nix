{
  description = "linehash (le): Fast, deterministic line editing CLI for LLMs";

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
          version = "0.1.0-ea07514";
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

{
  description = "Home-manager configuration";

  inputs = {
    utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    home-manager.url = "github:nix-community/home-manager/release-25.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, home-manager, nixpkgs, utils }:
    let
      pkgsForSystem = system: import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };

      mkHomeConfiguration = { system, username, homeDirectory, ... }@args:
        home-manager.lib.homeManagerConfiguration {
          modules = [ (import ./home.nix) ];
          pkgs = pkgsForSystem system;
          extraSpecialArgs = {
            inherit username homeDirectory;
          } // (args.extraSpecialArgs or {});
        };

    in
      utils.lib.eachSystem [ "x86_64-linux" "aarch64-darwin" "x86_64-darwin" ] (system: {
        legacyPackages = pkgsForSystem system;
        devShells.default = with pkgsForSystem system; mkShell {
          packages = [ home-manager.packages.${system}.default ];
        };
      })
      // {
        homeConfigurations = {
          "alessandro" = mkHomeConfiguration {
            system = "aarch64-darwin";
            username = "alessandro";
            homeDirectory = "/Users/alessandro";
          };
          "ale_tmp" = mkHomeConfiguration {
            system = "x86_64-linux";
            username = "ale_tmp";
            homeDirectory = "/home/ale_tmp";
          };
        };
      };
}

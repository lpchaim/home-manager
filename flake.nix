{
  description = "Home Manager configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, flake-utils, home-manager, ... } @inputs:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        makeHomeConfig = { extraModules ? [ ] }:
          home-manager.lib.homeManagerConfiguration {
            inherit pkgs;
            modules = [
              ./home.nix
            ] ++ extraModules;
          };
      in
      {
        packages.homeConfigurations = {
          cheina = makeHomeConfig { };
          lpchaim = makeHomeConfig { };
          lupec = makeHomeConfig { };
        };
        devShells.default = pkgs.mkShell {
          packages = with pkgs; [
            nil
            nixd
            nixpkgs-fmt
            pre-commit
            rnix-lsp
          ];
          shellHook = ''
            export LC_ALL="C.UTF-8"
            pre-commit install
          '';
        };
      }
    );
}

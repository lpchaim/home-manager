{
  description = "Home Manager configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixneovimplugins.url = "github:jooooscha/nixpkgs-vim-extra-plugins";
  };

  outputs = { nixpkgs, flake-utils, home-manager, ... } @ inputs:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          config = {
            allowUnfree = true;
            allowUnfreePredicate = _: true;
          };
          overlays = [
            inputs.nixneovimplugins.overlays.default
          ];
        };
        makeHomeConfig = modulesOrPaths:
          let
            modules = builtins.map
              (x: if (builtins.isPath x) then (import x) else x)
              modulesOrPaths;
          in
          home-manager.lib.homeManagerConfiguration {
            inherit pkgs;
            modules = modules ++ [
              (import ./modules/default.nix)
              inputs.nixvim.homeManagerModules.nixvim
            ];
          };
      in
      {
        packages.homeConfigurations = {
          "cheina@pc079" = makeHomeConfig [
            (import ./traits/base.nix { stateVersion = "23.05"; username = "cheina"; })
            ./traits/cheina.nix
            ./traits/non-nixos.nix
          ];
          "lpchaim@laptop" = makeHomeConfig [
            (import ./traits/base.nix { stateVersion = "23.11"; username = "lpchaim"; })
            ./traits/gnome.nix
            ./traits/gui.nix
          ];
          lpchaim = makeHomeConfig [ ];
          lupec = makeHomeConfig [ ];
        };
        devShells.default = pkgs.mkShell {
          packages = with pkgs; [
            nil
            nixd
            nixpkgs-fmt
            pre-commit
            rustup
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

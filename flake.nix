{
  description = "Template for my projects";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    flake-utils.url = "github:numtide/flake-utils";

    nixago = {
      url = "github:jmgilman/nixago";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        nixago-exts.follows = "nixago-exts";
        flake-utils.follows = "flake-utils";
      };
    };

    nixago-exts = {
      url = "github:nix-community/nixago-extensions";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        nixago.follows = "nixago";
        flake-utils.follows = "flake-utils";
      };
    };

    synergy = {
      url = "github:krostar/synergy";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    treefmt = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ {
    nixpkgs,
    synergy,
    ...
  }: let
    inherit (nixpkgs) lib;
  in
    synergy.lib.mkFlake {
      inherit inputs;
      src = ./nix;

      eval = {
        synergy = {
          mkPkgsForSystem = system: nixpkgs.legacyPackages.${system};
          restrictDependenciesUnits.synergy = ["synergy"];

          export = {
            # TODO: expose some easier-to-read way of doing this
            # choose a default shell
            # skip packages for some systems
            devShells = cfg: (builtins.mapAttrs (
                system: units:
                  {inherit (cfg.${system}.repo) default;}
                  // synergy.lib.attrsets.liftChildren "-" units
              )
              cfg);
            packages = cfg: (builtins.mapAttrs (
                system: units: (synergy.lib.attrsets.liftChildren "-" (builtins.mapAttrs (
                    _: packages: (lib.attrsets.filterAttrs (
                        name: _: !(lib.strings.hasSuffix "linux" system && name == "lorri-notifier")
                      )
                      packages)
                  )
                  units))
              )
              cfg);
          };
        };
      };
    };
}

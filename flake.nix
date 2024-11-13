{
  description = "Template for my projects";

  inputs = {
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-24.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    flake-utils.url = "github:numtide/flake-utils";

    darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };

    sops = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
      inputs.nixpkgs-stable.follows = "nixpkgs-stable";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };

    nixago = {
      url = "github:jmgilman/nixago";
      inputs = {
        nixpkgs.follows = "nixpkgs-unstable";
        nixago-exts.follows = "nixago-exts";
        flake-utils.follows = "flake-utils";
      };
    };

    nixago-exts = {
      url = "github:nix-community/nixago-extensions";
      inputs = {
        nixpkgs.follows = "nixpkgs-unstable";
        nixago.follows = "nixago";
        flake-utils.follows = "flake-utils";
      };
    };

    synergy = {
      url = "git+ssh://git@github.com/krostar/synergy";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    treefmt = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
  };

  outputs = inputs @ {
    nixpkgs-stable,
    synergy,
    ...
  }: let
    inherit (nixpkgs-stable) lib;
  in
    synergy.lib.mkFlake {
      inherit inputs;
      src = ./nix;

      eval = {
        synergy = {
          mkPkgsForSystem = system: nixpkgs-stable.legacyPackages.${system};

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

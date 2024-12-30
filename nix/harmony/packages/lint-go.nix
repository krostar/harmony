{
  data,
  flake,
  pkgs,
  unit,
  ...
}: let
  inherit (flake.inputs.nixpkgs-unstable.legacyPackages.${pkgs.system}) golangci-lint;
  inherit (unit.lib) nixago;
  inherit
    (nixago.make {
      inherit pkgs;
      file = nixago.files.golangci-lint;
      data = data.ci.linters.golangci-lint;
    })
    configFile
    ;
in
  pkgs.writeShellApplication {
    name = "lint-go";

    runtimeInputs = [pkgs.govulncheck golangci-lint];
    checkPhase = "";

    text = ''
      tolint=("./...")
      if [ "$#" -ne 0 ]; then
        tolint=("$@")
      fi

      golangci-lint run --config ${configFile} --verbose "''${tolint[@]}"
      govulncheck "''${tolint[@]}"
    '';
  }

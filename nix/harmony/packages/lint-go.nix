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
  pkgs.writeScriptBin "lint-go" ''
    #!/bin/sh

    set -o errexit # Exit immediately if a command exits with a non-zero status.
    set -o xtrace  # Print commands and their arguments as they are executed.

    ${golangci-lint}/bin/golangci-lint run --config ${configFile} --verbose "$@"
    ${pkgs.govulncheck}/bin/govulncheck ./...
  ''

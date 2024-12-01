{
  data,
  pkgs,
  unit,
  ...
}: let
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

    if [ "$#" -ne 0 ]; then
      >&2 echo "This script takes no arguments."
      exit 1
    fi

    set -o errexit # Exit immediately if a command exits with a non-zero status.
    set -o xtrace  # Print commands and their arguments as they are executed.

    ${pkgs.golangci-lint}/bin/golangci-lint run --config ${configFile} --verbose
    ${pkgs.govulncheck}/bin/govulncheck -v ./...
  ''

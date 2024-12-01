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
      file = nixago.files.yamllint;
      data = data.ci.linters.lint-yaml.yamllint;
    })
    configFile
    ;
in
  pkgs.writeScriptBin "lint-yaml" ''
    #!/bin/sh

    if [ "$#" -ne 0 ]; then
      >&2 echo "This script takes no arguments."
      exit 1
    fi

    set -o xtrace # Print commands and their arguments as they are executed.

    ${pkgs.yamllint}/bin/yamllint -c ${configFile} .
  ''

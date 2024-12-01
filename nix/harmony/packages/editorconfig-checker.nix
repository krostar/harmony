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
      file = nixago.files.editorconfig-checker;
      data = data.ci.editorconfig-checker;
    })
    configFile
    ;
in
  pkgs.writeScriptBin "editorconfig-checker" ''
    #!/bin/sh

    if [ "$#" -ne 0 ]; then
      >&2 echo "This script takes no arguments."
      exit 1
    fi

    set -o xtrace # Print commands and their arguments as they are executed.
    ${pkgs.editorconfig-checker}/bin/editorconfig-checker -config=${configFile}
  ''

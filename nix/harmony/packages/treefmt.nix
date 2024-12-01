{
  data,
  pkgs,
  unit,
  ...
}: let
  treefmt =
    (unit.lib.treefmt.eval {
      inherit pkgs;
      config = data.dev.formatters.treefmt.${pkgs.system};
    })
    .config;
in
  pkgs.writeScriptBin "treefmt" ''
    #!${pkgs.bash}/bin/bash

    set -o xtrace # Print commands and their arguments as they are executed.

    ${treefmt.package}/bin/treefmt                \
      --config-file=${treefmt.build.configFile}   \
      --tree-root-file=${treefmt.projectRootFile} \
      "$@"
  ''

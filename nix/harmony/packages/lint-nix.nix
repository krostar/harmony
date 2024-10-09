{
  data,
  pkgs,
  ...
}: let
  config = data.ci.linters.lint-nix;
in
  pkgs.writeScriptBin "lint-nix" ''
    #!${pkgs.bash}/bin/bash

    if [ "$#" -ne 0 ]; then
      >&2 echo "This script takes no arguments."
      exit 1
    fi

    set -o errexit # Exit immediately if a command exits with a non-zero status.
    set -o xtrace  # Print commands and their arguments as they are executed.

    ${pkgs.alejandra}/bin/alejandra --check --quiet ${
      builtins.concatStringsSep " " (builtins.map (i: "--exclude ${i}") config.alejandra.exclude)
    } .

    ${pkgs.statix}/bin/statix check ${
      if builtins.length config.statix.ignore > 0
      then "--ignore ${builtins.concatStringsSep " " config.statix.ignore}"
      else ""
    } .

    ${pkgs.deadnix}/bin/deadnix --fail --hidden ${
      if builtins.length config.deadnix.exclude > 0
      then "--exclude ${builtins.concatStringsSep " " config.deadnix.exclude}"
      else ""
    } -- .
  ''

{
  data,
  lib,
  pkgs,
  ...
}: let
  config = data.ci.linters.lint-ghaction;
in
  pkgs.writeScriptBin "lint-ghaction" ''
    #!/bin/sh

    if [ "$#" -ne 0 ]; then
        >&2 echo "This script takes no arguments."
        exit 1
    fi

    set -o xtrace    # Print commands and their arguments as they are executed.

    ${pkgs.actionlint}/bin/actionlint               \
      -shellcheck ${pkgs.shellcheck}/bin/shellcheck \
      ${lib.strings.concatStringsSep " " (builtins.map (ignore: "-ignore ${lib.strings.escapeShellArg ignore}") config.ignore or [])}
  ''

{
  data,
  lib,
  pkgs,
  ...
}: let
  config = data.ci.linters.lint-sh.${pkgs.system};
in
  pkgs.writeScriptBin "lint-sh" ''
    #!${pkgs.bash}/bin/bash

    set -o errexit   # Exit immediately if a command exits with a non-zero status.
    set -o noclobber # Prevent overwriting of files by redirection (e.g., > file).
    set -o nounset   # Treat unset variables as an error and exit immediately.
    set -o pipefail  # Return the exit status of the last command in the pipe that failed.

    get_files_to_check() {
      local -a files

      files=(${builtins.concatStringsSep " " config.additionalFiles})
      local -a found; readarray -d "" -t found < <(find . -type f \( ${builtins.concatStringsSep " -o " (builtins.map (f: "-name ${lib.strings.escapeShellArg f}") config.findFiles)} \) -print0)
      files+=("''${found[@]}")
      files+=("$0")

      printf '%s\0' "''${files[@]}"
    }

    run_linting_tools() {
      local -a -r files=("$@")

      set -o xtrace # Print commands and their arguments as they are executed.

      ${pkgs.shellcheck}/bin/shellcheck "''${files[@]}"
      ${pkgs.bashate}/bin/bashate --ignore E003,E006 "''${files[@]}"
      ${pkgs.shellharden}/bin/shellharden --check "''${files[@]}" || ${pkgs.shellharden}/bin/shellharden --suggest "''${files[@]}"
    }

    main() {
      if [ "$#" -ne 0 ]; then
        >&2 echo "This script takes no arguments."
        exit 1
      fi

      local -a files; readarray -d "" -t files < <(get_files_to_check)
      run_linting_tools "''${files[@]}"
    }

    main "$@"
  ''

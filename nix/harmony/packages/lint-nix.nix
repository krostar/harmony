{
  data,
  pkgs,
  ...
}: let
  config = data.ci.linters.lint-nix;
in
  pkgs.writeShellApplication {
    name = "lint-nix";

    runtimeInputs = with pkgs; [alejandra deadnix statix];
    checkPhase = "";

    text = ''
      tolint=(".")
      if [ "$#" -ne 0 ]; then
        tolint=("$@")
      fi

      alejandra --check --quiet ${
        builtins.concatStringsSep " " (builtins.map (i: "--exclude ${i}") config.alejandra.exclude)
      } "''${tolint[@]}"

      statix check ${
        if builtins.length config.statix.ignore > 0
        then "--ignore ${builtins.concatStringsSep " " config.statix.ignore}"
        else ""
      } "''${tolint[@]}"

      deadnix --fail --hidden ${
        if builtins.length config.deadnix.exclude > 0
        then "--exclude ${builtins.concatStringsSep " " config.deadnix.exclude}"
        else ""
      } -- "''${tolint[@]}"
    '';
  }

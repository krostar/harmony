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
  pkgs.writeShellApplication {
    name = "treefmt";

    runtimeInputs = [treefmt.package];
    checkPhase = "";

    text = ''
      tofmt=(".")
      if [ "$#" -ne 0 ]; then
        tofmt=("$@")
      fi

      treefmt                                       \
        --config-file=${treefmt.build.configFile}   \
        --tree-root-file=${treefmt.projectRootFile} \
        "''${tofmt[@]}"
    '';
  }

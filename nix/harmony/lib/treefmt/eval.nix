{
  flake,
  unit,
  ...
}: {
  config,
  pkgs,
}:
pkgs.lib.evalModules {
  modules =
    (flake.inputs.treefmt.lib.all-modules pkgs)
    ++ [
      unit.lib.treefmt.options.gci
      unit.lib.treefmt.options.goimports
      config
    ];
}

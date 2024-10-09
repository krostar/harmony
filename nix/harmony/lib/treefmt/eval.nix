{flake, ...}: {
  config,
  pkgs,
}:
flake.inputs.treefmt.lib.evalModule pkgs config

{
  pkgs,
  unit,
  units,
  ...
}: let
  nixagoFiles = units.harmony.lib.nixago.makeAll {
    inherit pkgs;
    configs = builtins.attrValues unit.nixago;
    log = false;
  };
in
  pkgs.mkShellNoCC
  {
    inherit (nixagoFiles) shellHook;

    nativeBuildInputs =
      (with units.harmony.packages; [
        lint-editorconfig
        lint-ghaction
        lint-nix
        lint-renovate
        lint-sh
        lint-yaml
        renovate-diff
        treefmt
      ])
      ++ (with pkgs; [
        cue
        jq
        nix-diff
        nix-tree
      ]);
  }

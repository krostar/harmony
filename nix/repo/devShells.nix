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
        lint-sh
        lint-yaml
        treefmt
      ])
      ++ (with pkgs; [
        cue
        nix-diff
        nix-tree
      ]);
  }

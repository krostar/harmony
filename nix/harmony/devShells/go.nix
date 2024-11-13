{
  pkgs,
  data,
  units,
  ...
}: let
  nixagoFiles = units.harmony.lib.nixago.makeAll {
    inherit pkgs;
    configs = [(units.harmony.lib.nixago.files.editorconfig data.dev.editorconfig pkgs)];
    log = false;
  };
in
  pkgs.mkShellNoCC
  {
    inherit (nixagoFiles) shellHook;

    nativeBuildInputs =
      (with units.harmony.packages; [
        editorconfig-checker
        lint-ghaction
        lint-go
        lint-nix
        lint-sh
        lint-yaml
        treefmt
      ])
      ++ (with pkgs; [
        go_1_23
        nix-diff
        nix-tree
      ]);
  }

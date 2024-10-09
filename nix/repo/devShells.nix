{
  pkgs,
  self,
  units,
  ...
}: let
  nixagoFiles = units.harmony.lib.nixago.makeAll {
    inherit pkgs;
    configs = builtins.attrValues self.nixago;
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
        lint-nix
        lint-sh
        lint-yaml
        treefmt
      ])
      ++ (with pkgs; [
        alejandra
        nix-diff
      ]);
  }

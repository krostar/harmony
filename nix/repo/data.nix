{
  pkgs,
  units,
  ...
}: {
  ci.linters = {
    lint-sh.${pkgs.system}.additionalFiles = builtins.map (f: "${f}/bin/*") (with units.harmony.packages; [
      lint-editorconfig
      lint-ghaction
      lint-go
      lint-nix
      lint-yaml
      treefmt
    ]);
  };
}

{
  pkgs,
  units,
  ...
}: {
  ci.linters = {
    lint-sh.${pkgs.system}.additionalFiles = builtins.map (f: "${f}/bin/*") (with units.harmony.packages; [
      editorconfig-checker
      lint-ghaction
      lint-go
      lint-nix
      lint-yaml
      treefmt
    ]);
  };
}

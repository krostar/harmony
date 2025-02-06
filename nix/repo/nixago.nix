{
  data,
  pkgs,
  units,
  ...
}: let
  inherit (units.harmony.lib) nixago;
in {
  editorconfig = nixago.files.editorconfig data.${pkgs.system}.dev.editorconfig pkgs;
}

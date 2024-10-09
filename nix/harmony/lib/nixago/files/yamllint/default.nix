{
  lib,
  self,
  ...
}: data: pkgs: let
  engines = self.lib.nixago.engines pkgs;
  output = "yamllint.yaml";
in {
  inherit data output;
  apply = data: (data
    // {
      ignore = lib.lists.unique (
        (lib.attrsets.attrByPath ["ignore"] [] data) ++ [output]
      );
    });
  engine = engines.cue {
    files = [./schema.cue];
  };
}
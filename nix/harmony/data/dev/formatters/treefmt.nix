{
  pkgs,
  flake,
  ...
}: let
  pkgsUnstable = flake.inputs.nixpkgs-unstable.legacyPackages;
in {
  "${pkgs.system}" = {
    package = pkgsUnstable.${pkgs.system}.treefmt;
    projectRootFile = "flake.nix";
    programs = {
      alejandra.enable = true;
      cue.enable = true;
      jsonfmt.enable = true;
      mdformat.enable = true;
      mdsh.enable = true;
      shfmt.enable = true;
      yamlfmt.enable = true;
    };
    settings.formatter.yamlfmt.options = ["-formatter" "include_document_start=true,trim_trailing_whitespace=true,retain_line_breaks_single=true"];
  };
}

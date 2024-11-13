{
  pkgs,
  flake,
  ...
}: {
  "${pkgs.system}" = let
    pkgsUnstable = flake.inputs.nixpkgs-unstable.legacyPackages.${pkgs.system};
  in {
    package = pkgsUnstable.treefmt; # we need argument '--tree-root-file'
    projectRootFile = "flake.nix";
    programs = {
      alejandra.enable = true;
      cue.enable = true;
      jsonfmt.enable = true;
      mdformat = {
        enable = true;
        package = pkgsUnstable.python312Packages.mdformat; # error with ghostscripts in darwin
      };
      mdsh.enable = true;
      shfmt.enable = true;
      yamlfmt.enable = true;
    };
    settings.formatter.yamlfmt.options = ["-formatter" "include_document_start=true,trim_trailing_whitespace=true,retain_line_breaks_single=true"];
  };
}

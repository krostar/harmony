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
      gci = {
        enable = true;
        order = ["standard" "default" "Prefix(github.com/krostar/)" "localmodule"];
      };
      gofumpt = {
        enable = true;
        extra = true;
      };
      goimports.enable = true;
      jsonfmt.enable = true;
      mdformat = {
        enable = true;
        package = pkgsUnstable.python312Packages.mdformat; # error with ghostscripts in darwin
      };
      mdsh.enable = true;
      shfmt.enable = true;
      yamlfmt.enable = true;
    };
    settings.formatter = {
      yamlfmt.options = ["-formatter" "include_document_start=true,trim_trailing_whitespace=true,retain_line_breaks_single=true"];
      gci.priority = 2;
      goimports.priority = 1;
      gofumpt.priority = 3;
    };
  };
}

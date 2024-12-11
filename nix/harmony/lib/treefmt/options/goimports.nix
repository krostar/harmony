_: {
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.programs.goimports;
in {
  meta.maintainers = ["krostar"];

  options.programs.goimports = {
    enable = lib.mkEnableOption "goimports";
    package = lib.mkPackageOption pkgs "gotools" {};
  };

  config = lib.mkIf cfg.enable {
    settings.formatter.goimports = {
      command = lib.meta.getExe' cfg.package "goimports";
      options = ["-w"];
      includes = ["*.go"];
      excludes = ["vendor/*"];
    };
  };
}

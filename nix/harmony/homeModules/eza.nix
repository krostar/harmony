_: {
  config,
  lib,
  modulesPath,
  pkgs,
  ...
}: {
  disabledModules = ["${modulesPath}/programs/eza.nix"];

  meta.maintainers = with lib.maintainers; [cafkafk krostar];

  options.programs.eza = {
    enable = lib.mkEnableOption "eza, a modern replacement for {command}`ls`";
    package = lib.mkPackageOption pkgs "eza" {};

    defaultFlags = lib.mkOption {
      type = with lib.types; listOf str;
      default = [];
      example = ["--icons --group-directories-first" "--header"];
      description = "Default flags always passed to eza.";
    };

    lsAlias = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Whether 'ls' should be replaced by 'eza' through shell alias.";
    };

    themeFile = lib.mkOption {
      type = with lib.types; nullOr path;
      default = null;
      description = "Whether 'ls' should be replaced by 'eza' through shell alias.";
    };
  };

  config = let
    cfg = config.programs.eza;

    defaultFlags =
      if (builtins.length cfg.defaultFlags > 0)
      then lib.escapeShellArgs cfg.defaultFlags
      else "";

    aliases =
      lib.attrsets.optionalAttrs (defaultFlags != "") {eza = "eza ${defaultFlags}";}
      // lib.attrsets.optionalAttrs cfg.lsAlias {ls = "eza";};
  in
    lib.mkIf cfg.enable {
      home = {
        packages = [cfg.package];

        sessionVariables = lib.attrsets.optionalAttrs (pkgs.stdenv.isDarwin && cfg.themeFile != null) {
          EZA_CONFIG_DIR = "${config.xdg.configHome}/eza";
        };

        file = lib.attrsets.optionalAttrs (cfg.themeFile != null) {
          eza-theme = {
            source = cfg.themeFile;
            target = "${config.xdg.configHome}/eza/theme.yml";
          };
        };
      };

      programs = {
        bash.shellAliases = aliases;
        zsh.shellAliases = aliases;
        fish.shellAliases = aliases;
        ion.shellAliases = aliases;
        nushell.shellAliases = aliases;
      };
    };
}

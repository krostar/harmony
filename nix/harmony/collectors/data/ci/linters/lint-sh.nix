_: {lib, ...}: {
  options.data.ci.linters.lint-sh = lib.mkOption {
    type = with lib.types;
      attrsOf (submodule {
        options = {
          findFiles = lib.mkOption {type = with lib.types; listOf str;};
          additionalFiles = lib.mkOption {type = with lib.types; listOf str;};
        };
      });
  };
}

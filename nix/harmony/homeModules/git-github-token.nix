_: {
  config,
  lib,
  ...
}: {
  meta.maintainers = with lib.maintainers; [krostar];

  options.programs.git.github-token = {
    url = lib.mkOption {
      type = lib.types.str;
      description = "Github URL.";
      default = "https://github.com";
    };

    user = lib.mkOption {
      type = lib.types.str;
      description = "Github user.";
    };

    file = lib.mkOption {
      type = lib.types.path;
      description = "Path to a file containing the github token.";
    };
  };

  config = let
    cfg = config.programs.git.github-token;
  in
    lib.mkIf (cfg.user != "" && cfg.file != "") {
      programs.git.extraConfig = {
        credential = {
          "${cfg.url}" = {
            username = cfg.user;
            helper = ''
              !f() { test \"$1\" = get && echo \"password=$(cat ${cfg.file})\"; };
              f
            '';
          };
        };
      };
    };
}

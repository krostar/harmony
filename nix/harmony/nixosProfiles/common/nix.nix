_: {
  lib,
  pkgs,
  ...
}: {
  system.switch = {
    enable = lib.mkDefault false;
    enableNg = lib.mkDefault true;
  };

  # Make builds to be more likely killed than important services.
  # 100 is the default for user slices and 500 is systemd-coredumpd@
  # We rather want a build to be killed than our precious user sessions as builds can be easily restarted.
  systemd.services.nix-daemon.serviceConfig.OOMScoreAdjust = lib.mkDefault 250;

  nix = {
    # package = pkgs.nixFlakes;
    package = pkgs.nixVersions.latest;
    channel.enable = false;

    distributedBuilds = true;
    extraOptions = ''
      builders-use-substitutes = true
    '';

    optimise = {
      automatic = true;
      dates = ["Sun *-*-* 06:00:00"];
    };

    gc = {
      automatic = true;
      dates = "Sun *-*-* 05:00:00";
      options = "--delete-older-than 7d";
    };

    settings = {
      auto-allocate-uids = true;
      log-lines = lib.mkDefault 25;
      experimental-features = lib.mkDefault ["auto-allocate-uids" "nix-command" "flakes"];
      builders-use-substitutes = true;
    };
  };
}

{
  config,
  nixpkgs,
  pkgs,
  ...
}: {
  nixpkgs.config.allowUnfree = true;

  nix = {
    package = pkgs.nixFlakes;

    extraOptions = ''
      experimental-features = nix-command flakes
    '';

    settings = {
      system-features = ["apple-virt" "benchmark" "big-parallel" "kvm" "nixos-test"];
      auto-optimise-store = true;
    };

    distributedBuilds = true;

    optimise = {
      automatic = true;
      interval.Weekday = 6;
    };

    gc = {
      automatic = true;
      interval.Weekday = 6;
      options = "--delete-older-than 7d";
    };
  };

  services.nix-daemon.enable = true;
}

{
  nix.linux-builder = {
    enable = true;
    supportedFeatures = ["kvm" "benchmark" "big-parallel" "nixos-test"];
    ephemeral = true;
  };

  launchd.daemons.linux-builder.serviceConfig = {
    StandardOutPath = "/var/log/nix/linux-builder.log";
    StandardErrorPath = "/var/log/nix/linux-builder.log";
  };
}

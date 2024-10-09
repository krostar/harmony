{
  nixpkgs.hostPlatform = "aarch64-darwin";
  nix.settings.extra-platforms = ["x86_64-darwin"];
}

{
  self,
  loaded,
  ...
}: {config, ...}: {
  imports =
    (with self.darwinModules; [
      home-manager
    ])
    ++ [
      ./brew.nix
      ./lorri.nix
      ./nix.nix
    ];

  nixpkgs.overlays = [
    (_: _: {
      inherit (loaded.systemized.${config.nixpkgs.hostPlatform.system}.packages.harmony) lorri-notifier;
    })
  ];
}

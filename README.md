# Harmony

Harmony leverages Synergy's modular design to offer a convenient way to share and manage development tools and settings across multiple projects. Instead of replicating these configurations in each individual project, Harmony exposes them so you can use it directly, or extend it based on your needs. This simplifies maintenance, ensures consistency, and reduces boilerplate code.

## Minimal example

```nix
# flake.nix
inputs.harmony.url = "git+ssh://git@github.com/krostar/harmony";
outputs = {harmony, ...}: {
  devShells = builtins.mapAttrs (system: shells: {default = shells.harmony-go;}) harmony.devShells;
  formatter = builtins.mapAttrs (system: pkgs: pkgs.harmony-treefmt) harmony.packages;
};
```

## More complete example

```nix
# flake.nix
inputs.harmony.url = "git+ssh://git@github.com/krostar/harmony";
outputs = inputs @ {synergy,...}: {
  synergy.lib.mkFlake {
    inherit inputs;
    src = ./nix;
  };
}
```

```nix
# nix/repo/devShell.nix
# {
  pkgs,
  deps,
  ...
}:
  pkgs.mkShellNoCC
  {
    nativeBuildInputs = (with deps.harmony.result.packages.harmony; [
      lint-yaml
      treefmt
    ]);
  }
```

```nix
# nix/repo/data.nix
{
  ci.linters.yamllint.ignore = [./custom-file-to-ignore.yaml];
}
```

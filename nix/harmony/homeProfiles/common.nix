{flake, ...}: {config, ...}: {
  imports = [flake.inputs.sops.homeManagerModule];

  programs = {
    fish.enable = true;
    home-manager.enable = true;
    ssh.enable = true;
    tmux.enable = true;
  };

  sops.age.keyFile = "${config.xdg.configHome}/sops/age/keys.txt";

  xdg.enable = true;
}

_: {pkgs, ...}: {
  programs.git.ignores = [".DS_Store"];

  home = {
    sessionVariables."DOCKER_HOST" = "unix://$HOME/.colima/docker.sock";
    packages = [
      pkgs.docker-credential-helpers
      pkgs.colima
      pkgs.docker
    ];
  };
}

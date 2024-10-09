{pkgs, ...}: {
  "${pkgs.system}" = {
    findFiles = ["*.sh" "*.bash" "*.zsh"];
    additionalFiles = ["./.envrc"];
  };
}

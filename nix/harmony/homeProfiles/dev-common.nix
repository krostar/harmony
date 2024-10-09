{self, ...}: {pkgs, ...}: {
  imports = with self.homeModules; [eza];

  home.packages = [pkgs.nixd];

  programs = {
    direnv.enable = true;
    git = {
      enable = true;
      ignores = [".idea/"];
    };
    ssh = {
      matchBlocks = {
        "github" = {
          host = "github.com";
          user = "git";
          identitiesOnly = true;
        };
      };
    };
  };
}

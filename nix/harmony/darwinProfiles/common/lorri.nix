{pkgs, ...}: {
  services.lorri = {
    enable = true;
    logFile = "/var/log/nix/lorri.log";
  };

  launchd.user.agents.lorri-notifier = {
    command = "${pkgs.lorri-notifier}/bin/lorri-notifier";
    serviceConfig = {
      KeepAlive = true;
      RunAtLoad = true;
      ProcessType = "Background";
      StandardOutPath = "/var/log/nix/lorri-notifier.log";
      StandardErrorPath = "/var/log/nix/lorri-notifier.log";
    };
  };
}

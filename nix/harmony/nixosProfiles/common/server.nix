_: {
  config,
  lib,
  ...
}: {
  time.timeZone = lib.mkDefault "UTC";

  security = {
    sudo = {
      wheelNeedsPassword = lib.mkDefault false;
      extraConfig = ''
        Defaults lecture = never
      '';
    };
  };

  services.openssh = {
    openFirewall = lib.mkDefault true;
    ports = lib.mkDefault [22];
  };

  users.mutableUsers = lib.mkDefault false;

  boot = {
    # Use systemd during boot as well except:
    # - systems with raids as this currently require manual configuration: https://github.com/NixOS/nixpkgs/issues/210210
    # - for containers we currently rely on the `stage-2` init script that sets up our /etc
    initrd.systemd = {
      enable = lib.mkDefault (!config.boot.swraid.enable && !config.boot.isContainer);
      enableTpm2 = false; # https://github.com/NixOS/nixos-hardware/issues/858
    };
    # Ensure a clean & sparkling /tmp on fresh boots.
    tmp.cleanOnBoot = lib.mkDefault true;

    # use TCP BBR has significantly increased throughput and reduced latency for connections
    kernel.sysctl = {
      "net.core.default_qdisc" = "fq";
      "net.ipv4.tcp_congestion_control" = "bbr";
    };
  };

  environment = {
    # Don't install the /lib/ld-linux.so.2 stub. This saves one instance of nixpkgs.
    ldso32 = null;
    # Don't install the /lib/ld-linux.so.2 and /lib64/ld-linux-x86-64.so.2
    # stubs. Server users should know what they are doing.
    stub-ld.enable = false;
  };

  # Work around for https://github.com/NixOS/nixpkgs/issues/124215
  documentation.info.enable = false;

  xdg = {
    autostart.enable = false;
    icons.enable = false;
    menus.enable = false;
    mime.enable = false;
    sounds.enable = false;
  };

  fonts.fontconfig.enable = false;

  programs.command-not-found.enable = false;
}

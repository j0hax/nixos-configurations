{
  lib,
  pkgs,
  config,
  ...
}:
let
  cfg = config.jka.desktop;
in
{
  imports = [
    ./gnome.nix
    ./sway.nix
    ./cosmic.nix
    ./plasma.nix
    ./niri.nix
    ./gaming.nix

    ./location.nix
    ./services.nix
    ./packages.nix
    ./dev.nix
    ./fun.nix
    ./fonts.nix
  ];

  options.jka.desktop = {
    enable = lib.mkEnableOption "desktop environment and GUI applications";
  };

  config = lib.mkIf cfg.enable {
    boot = {
      # Use a tweaked Kernel by default
      kernelPackages = pkgs.linuxPackages_latest;

      # Use a pretty boot screen
      loader = {
        timeout = 0;
        systemd-boot = {
          consoleMode = "max";
          memtest86.enable = true;
          netbootxyz.enable = true;
        };
      };
      plymouth.enable = true;

      kernelParams = [
        "quiet"
        "splash"
      ];
    };

    # Use NetworkManager for desktop configurations
    networking.networkmanager = lib.mkDefault {
      enable = true;
      wifi = {
        macAddress = "stable-ssid";
      };
      ethernet.macAddress = "stable";
      dns = "systemd-resolved";
    };

    # Limit how many resources Nix can eat up
    nix = {
      settings = {
        cores = 8;
        max-jobs = 2;
      };
      daemonIOSchedClass = "idle";
      daemonCPUSchedPolicy = "idle";
    };

    security.rtkit.enable = true;

    # Required for controlling monitors
    hardware.i2c.enable = true;
  };
}

{
  lib,
  pkgs,
  ...
}:
{
  imports = [
    #./greetd.nix
    #./sway.nix
    #./gnome.nix
    #./cosmic.nix
    # ./plasma.nix
    ./niri.nix

    ./services.nix
    ./packages.nix
    ./fonts.nix
  ];

  # Use a pretty boot screen
  boot = {
    loader = {
      timeout = 1;
      systemd-boot = {
        consoleMode = "max";
        memtest86.enable = true;
        netbootxyz.enable = true;
      };
    };
    plymouth = {
      enable = true;
      theme = "tribar";
    };

    kernelParams = [
      "quiet"
      "splash"
    ];
  };

  # Use NetworkManager for desktop configurations
  networking.networkmanager = lib.mkDefault {
    enable = true;
    wifi = {
      backend = "iwd";
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

  #services.dbus.implementation = "broker";
  security.rtkit.enable = true;

  # Required for controlling monitors
  hardware.i2c.enable = true;
}

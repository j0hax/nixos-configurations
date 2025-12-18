{
  pkgs,
  config,
  lib,
  ...
}:
{
  imports = [
    #./greetd.nix
    #./sway.nix
    #./gnome.nix
    #./cosmic.nix
    ./plasma.nix
    ./niri.nix

    ./services.nix
    ./packages.nix
    ./fonts.nix
  ];

  # Use a pretty boot screen
  boot = {
    loader = {
      timeout = 0;
      systemd-boot.consoleMode = "auto";
    };
    plymouth.enable = true;
  };

  # Use NetworkManager for desktop configurations
  networking.networkmanager = lib.mkDefault {
    enable = true;
    wifi.backend = "iwd";
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

  # Further configuration in Home-Manager
  # programs.hyprland.enable = true;
  programs.niri.enable = true;

  # Performance tweaks
  #services.dbus.implementation = "broker";
  security.rtkit.enable = true;

  # Required for controlling monitors
  hardware.i2c.enable = true;
}

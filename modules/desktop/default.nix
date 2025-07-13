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
    ./gnome.nix
    #./cosmic.nix
    #./plasma.nix

    ./services.nix
    ./packages.nix
    ./fonts.nix
  ];

  # Use NetworkManager for desktop configurations
  networking.networkmanager = lib.mkDefault {
    enable = true;
    wifi.backend = "iwd";
    #dns = "systemd-resolved";
  };

  # Further configuration in Home-Manager
  programs.hyprland.enable = true;

  # Performance tweaks
  #services.dbus.implementation = "broker";
  security.rtkit.enable = true;
}

{
  pkgs,
  config,
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

  # Further configuration in Home-Manager
  programs.hyprland.enable = true;

  # Performance tweaks
  #services.dbus.implementation = "broker";
  security.rtkit.enable = true;
}

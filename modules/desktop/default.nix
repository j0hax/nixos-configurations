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

    ./services.nix
    ./packages.nix
    ./fonts.nix
  ];

  # Performance tweaks
  services.dbus.implementation = "broker";
  security.rtkit.enable = true;
}

{
  pkgs,
  inputs,
  ...
}:
{

  imports = [
    inputs.noctalia.nixosModules.default
  ];

  programs = {
    noctalia = {
      enable = true;
      # Enables NetworkManager, Bluetooth, UPower, and a power profile service.
      recommendedServices.enable = true;
    };
    niri.enable = true;
    foot = {
      enable = true;
      settings = {
        main = {
          font = "Iosevka:size=16";
        };
      };
    };
    seahorse.enable = true;
  };

  # Polkit authentication
  # security.soteria.enable = true;

  # Required for Nautilus to fully function
  services.gvfs.enable = true;

  environment.systemPackages = with pkgs; [
    ddcutil
    xwayland-satellite
    posy-cursors
    quickshell
    kdlfmt
    libnotify
    swww

    # Select GNOME apps
    nautilus
    papers
    loupe
    file-roller
    adwaita-icon-theme
    transmission_4-gtk
  ];
}

{
  pkgs,
  config,
  ...
}:
{
  services.xserver = {
    enable = true;
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
  };

  programs.kdeconnect = {
    enable = true;
    package = pkgs.gnomeExtensions.gsconnect;
  };

  environment.systemPackages = with pkgs; [
    transmission_4-gtk
    gnome-network-displays
    gnomeExtensions.paperwm
  ];
}

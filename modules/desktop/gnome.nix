{
  pkgs,
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
    impression # Bootable Drive Tool
    gnome-decoder # QR Code Generator
    metadata-cleaner
    gnome-obfuscate
    eyedropper
    shortwave
    video-trimmer
    flare-signal
    #varia
    bottles
    gnome-2048
    gnome-firmware
    gnome-solanum
  ];
}

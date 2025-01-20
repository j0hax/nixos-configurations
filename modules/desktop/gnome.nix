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

    # Extra gnome apps
    gnome-network-displays
    impression # Bootable Drive Tool
    gnome-decoder # QR Code Generator
    metadata-cleaner
    gnome-obfuscate
    junction
    eyedropper
    shortwave
    video-trimmer
    gnomeExtensions.caffeine
    flare-signal
    varia
    bottles
    gnome-2048
  ];
}

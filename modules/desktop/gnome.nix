{
  pkgs,
  ...
}:
{
  services = {
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
  };

  programs.kdeconnect = {
    enable = true;
    package = pkgs.gnomeExtensions.gsconnect;
  };

  # Additional GTK Packages
  environment.systemPackages = with pkgs; [
    transmission_4-gtk
    gnome-network-displays
    impression # Bootable Drive Tool
    gnome-decoder # QR Code Generator
    metadata-cleaner
    gnome-obfuscate # Redaction tool
    eyedropper
    shortwave # Internet radio
    video-trimmer
    varia
    bottles
    gnome-2048
    gnome-firmware
    gnome-solanum # Pomodoro timer
    helvum # Patchbay
    foliate # E-Reader
    deja-dup # Backup tool
  ];
}

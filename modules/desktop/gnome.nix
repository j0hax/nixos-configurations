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

  # Enable the GNOME RDP components
  services.gnome.gnome-remote-desktop.enable = true;

  # Ensure the service starts automatically at boot so the settings panel appears
  systemd.services.gnome-remote-desktop = {
    wantedBy = [ "graphical.target" ];
  };

  # Open the default RDP port (3389)
  networking.firewall.allowedTCPPorts = [ 3389 ];

  # Disable autologin to avoid session conflicts
  services.displayManager.autoLogin.enable = false;
  services.getty.autologinUser = null;

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
    fractal # Matrix messenger
  ];
}

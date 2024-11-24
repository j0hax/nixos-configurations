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

  # Remove the following Gnome apps
  environment.gnome.excludePackages = (
    with pkgs;
    [
      gnome-photos
      gnome-tour
      gedit
      cheese # webcam tool
      gnome-music
      gnome-terminal
      epiphany # web browser
      geary # email reader
      evince # document viewer
      gnome-characters
      totem # video player
      tali # poker game
      iagno # go game
      hitori # sudoku game
      atomix # puzzle game
    ]
  );

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
  ];
}

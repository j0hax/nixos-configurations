{ pkgs, lib, ... }: {
  # Enable gnome
  services.xserver = lib.mkDefault {
    enable = true;
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
  };

  # Enable some gnome programs
  programs = lib.mkDefault {
    gnome-disks.enable = true;
    gnome-terminal.enable = true;
    # Broken
    #gnome-documents.enable = true;
  };
}

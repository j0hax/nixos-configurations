{ pkgs, lib, ... }: {
  # Enable gnome
  services.xserver = lib.mkDefault {
    enable = true;
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
  };

  programs.sway.enable = lib.mkDefault true;
}

{ pkgs, lib, ... }: {
  services.xserver = {
    enable = lib.mkDefault true;
    displayManager.sddm.enable = lib.mkDefault true;
    desktopManager.plasma5.enable = lib.mkDefault true;
  };

  programs.sway.enable = lib.mkDefault true;
}

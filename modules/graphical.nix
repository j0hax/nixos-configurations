{ pkgs, lib, ... }: {
  services.xserver = {
    enable = lib.mkDefault true;
    displayManager.sddm.enable = lib.mkDefault true;
    desktopManager = {
      plasma5.enable = lib.mkDefault true;

      retroarch = {
        enable = lib.mkDefault true;
        package = pkgs.retroarchFull;
      };
    };
  };

  programs.sway.enable = lib.mkDefault true;
}

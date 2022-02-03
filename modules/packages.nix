{ config, lib, pkgs, ... }: {
  # Base packages for desktop usage
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    bc
    file
    git
    go
    killall
    parallel
    python3
    unrar
    usbutils
    wget
    wineWowPackages.staging
  ];

  # Certain programs
  programs.vim.defaultEditor = lib.mkDefault true;
  programs.java.enable = lib.mkDefault true;
  programs.adb.enable = lib.mkDefault true;
  programs.thefuck.enable = lib.mkDefault true;
  programs.tmux.enable = lib.mkDefault true;
  programs.gnupg.agent.enable = lib.mkDefault true;
  programs.iftop.enable = lib.mkDefault true;
  programs.wireshark = {
    enable = lib.mkDefault true;
    package = pkgs.wireshark-qt;
  };

  # Enable firmware updates
  services.fwupd.enable = lib.mkDefault true;

  # Some smaller hardware tweaks
  services.udev.packages = with pkgs; [ logitech-udev-rules ];
}

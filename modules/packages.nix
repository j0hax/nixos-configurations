{ config, pkgs, ... }: {
  # Base packages for desktop usage
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    bc
    file
    git
    killall
    parallel
    python3
    unrar
    usbutils
    wget
    wineWowPackages.staging
  ];

  # Certain programs
  programs.vim.defaultEditor = true;
  programs.java.enable = true;
  programs.adb.enable = true;
  programs.thefuck.enable = true;
  programs.tmux.enable = true;
  programs.gnupg.agent.enable = true;
  programs.iftop.enable = true;
  programs.tilp2.enable = true;
  programs.wireshark = {
    enable = true;
    package = pkgs.wireshark-qt;
  };

  # Enable firmware updates
  services.fwupd.enable = true;

  # Some smaller hardware tweaks
  services.udev.packages = with pkgs; [ logitech-udev-rules ];
}

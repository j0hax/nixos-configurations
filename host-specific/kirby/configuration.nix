{ config, pkgs, ... }:
{
  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.loader.systemd-boot.consoleMode = "max";

  networking.hostName = "kirby"; # Define your hostname.
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Amsterdam";

  # Enable the Plasma 5 Desktop Environment
  services.xserver.enable = true;
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;

  services.xserver.displayManager.autoLogin = {
    enable = true;
    user = "johannes";
  };

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  users.users.johannes.extraGroups = [ "vboxusers" ];
  virtualisation.virtualbox.host.enable = true;
  #virtualisation.virtualbox.host.enableExtensionPack = true;

  # Maintenance
  services.zfs.autoScrub.enable = true;
  services.btrfs.autoScrub.enable = true;
  
  # Clight
  services.clight.enable = true;

  nix = {
    package = pkgs.nixFlakes;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };
}


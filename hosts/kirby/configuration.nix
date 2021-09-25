{ config, pkgs, nixos-hardware, ... }: {
  imports = [
    ./hardware-configuration.nix
    nixos-hardware.nixosModules.lenovo-thinkpad-x230
    nixos-hardware.nixosModules.common-pc-ssd
  ];

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

  # Encrypted SSD via SD Card
  #boot.initrd.kernelModules = [ "usb_storage" ];
  boot.initrd.luks.devices."cryptroot" = {
  #  keyFileSize = 4096;
  #  keyFile = "/dev/mmcblk0";
    bypassWorkqueues = true;
    allowDiscards = true;
  };

  # New Cryptenroll method
  environment.etc.crypttab = {
    enable = true;
    text = ''
      cryptroot /dev/sda2 - fido2-device=auto
    '';
  };

  # Location services
  services.geoclue2.enable = true;

  # Clight is broken
  #services.clight.enable = true;

  # Localtime for travelling
  #services.localtime.enable = true;

  nix = {
    package = pkgs.nixFlakes;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  hardware.trackpoint = {
    enable = true;
    speed = 255;
  };
}


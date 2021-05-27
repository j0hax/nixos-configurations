{ config, pkgs, ... }:
{
  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.loader.systemd-boot.consoleMode = "max";

  # Use the Zen kernel
  boot.kernelPackages = pkgs.linuxPackages_zen;
  
  # Enable Zramswap
  zramSwap.enable = true;

  networking.hostName = "kirby"; # Define your hostname.
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Amsterdam";

  users.users.johannes = {
    description = "Johannes Arnold";
    isNormalUser = true;
    extraGroups = [ "wheel" "vboxusers" ]; # Enable ‘sudo’ for the user.
  };

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

  virtualisation.virtualbox.host.enable = true;
  #virtualisation.virtualbox.host.enableExtensionPack = true;

  # Shell Preferences
  programs.bash.promptInit = ''eval "$(starship init bash)"'';
  programs.thefuck.enable = true;
  environment.shellAliases = { "cat" = "bat"; };
  environment.homeBinInPath = true;

  # Maintenance
  services.zfs.autoScrub.enable = true;
  services.btrfs.autoScrub.enable = true;

  nix = {
    package = pkgs.nixFlakes;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };
}


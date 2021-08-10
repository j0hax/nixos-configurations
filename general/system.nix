{ config, pkgs, lib, ... }: {

  # Use the Zen kernel
  # Disabled until #122606 is fixed
  #boot.kernelPackages = lib.mkDefault pkgs.linuxPackages_zen;

  # Enable Zramswap
  zramSwap.enable = lib.mkDefault true;

  # Remote access is critical
  services.openssh.enable = true;

  # Auto-Upgrade the system
  system.autoUpgrade = lib.mkDefault {
    enable = true;
    flake = "github:j0hax/nixos-configurations";
  };

  # Add myself as a user
  users.users.johannes = {
    description = "Johannes Arnold";
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "dialout" ];
  };
}

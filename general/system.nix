{ config, pkgs, ... }:
{

  # Use the Zen kernel
  boot.kernelPackages = pkgs.linuxPackages_zen;
  
  # Enable Zramswap
  zramSwap.enable = true;

  # Remote access is critical
  services.openssh.enable = true;
  
  # Auto-Upgrade the system
  system.autoUpgrade = {
    enable = true;
    flake = "github:j0hax/nixos-configurations";
  };

  # Add myself as a user
  users.users.johannes = {
    description = "Johannes Arnold";
    isNormalUser = true;
    extraGroups = [ "wheel" ];
  };
}

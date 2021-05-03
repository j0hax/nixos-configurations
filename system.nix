{ config, ... }:
{
  # Remote access is critical
  services.openssh.enable = true;

  # Add myself as a user
  users.users.johannes = {
    description = "Johannes Arnold";
    isNormalUser = true;
    extraGroups = [ "wheel" ];
  };

  # Keep system clean
  nix.gc.automatic = true;
  nix.autoOptimiseStore = true;
  nix.optimise.automatic = true;

  boot.tmpOnTmpfs = true;
}

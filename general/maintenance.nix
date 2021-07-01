{ config, pkgs, ... }: {
  # Keep system clean
  nix.gc.automatic = true;
  nix.autoOptimiseStore = true;
  nix.optimise.automatic = true;

  boot.tmpOnTmpfs = true;
}

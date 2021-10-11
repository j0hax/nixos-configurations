{ config, lib, pkgs, ... }:

let
  fsExists = fs:
    (builtins.any (filesystem: filesystem.fsType == fs)
      (lib.attrValues config.fileSystems));
in {
  # Keep system clean
  nix.gc.automatic = true;
  nix.autoOptimiseStore = true;
  nix.optimise.automatic = true;

  boot.tmpOnTmpfs = true;

  # Enable trim
  services.fstrim.enable = true;

  # Auto scrub filesystems that support it
  services.btrfs.autoScrub.enable = lib.mkDefault (fsExists "btrfs");
  services.zfs.autoScrub.enable = lib.mkDefault (fsExists "zfs");
}

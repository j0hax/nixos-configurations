{ config, lib, pkgs, ... }: {
  # Keep system clean
  nix.gc.automatic = true;
  nix.autoOptimiseStore = true;
  nix.optimise.automatic = true;

  boot.tmpOnTmpfs = true;

  # Auto scrub filesystems that support it
  services.zfs.autoScrub.enable = lib.mkDefault
    (builtins.any (filesystem: filesystem.fsType == "zfs")
      (builtins.attrValues config.fileSystems));
  services.btrfs.autoScrub.enable = lib.mkDefault
    (builtins.any (filesystem: filesystem.fsType == "btrfs")
      (builtins.attrValues config.fileSystems));
}

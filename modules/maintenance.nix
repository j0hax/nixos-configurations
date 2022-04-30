{ config, lib, pkgs, ... }:

let
  fsExists = fs:
    (builtins.any (filesystem: filesystem.fsType == fs)
      (lib.attrValues config.fileSystems));
in {
  # Keep system clean
  nix = {
    gc = {
      automatic = lib.mkDefault true;
      options = "--delete-older-than 3d";
    };
    settings.auto-optimise-store = lib.mkDefault true;
    optimise.automatic = lib.mkDefault true;
  };

  # Explicitly use tmpfs to save disk writes
  boot.tmpOnTmpfs = lib.mkDefault true;
  environment.variables.TMPDIR = "/tmp";

  # Enable trim
  services.fstrim.enable = lib.mkDefault true;

  # Auto scrub filesystems that support it
  services.btrfs.autoScrub.enable = lib.mkDefault (fsExists "btrfs");
  services.zfs.autoScrub.enable = lib.mkDefault (fsExists "zfs");
}

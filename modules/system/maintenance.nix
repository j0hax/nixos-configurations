{
  lib,
  config,
  ...
}:
let
  hasBtrfs = lib.any (fs: fs.fsType == "btrfs") (lib.attrValues config.fileSystems);
in
{
  # https://wiki.nixos.org/wiki/Automatic_system_upgrades
  system.autoUpgrade = lib.mkDefault {
    enable = true;
    flake = config.jka.flakePath;
    allowReboot = true;
    rebootWindow = {
      lower = "01:00";
      upper = "05:00";
    };
    runGarbageCollection = true;
  };

  # Prevent boot from filling up
  boot.loader.grub.configurationLimit = 5;

  # Scrub btrfs filesystems monthly if any are present
  services.btrfs.autoScrub = lib.mkIf hasBtrfs {
    enable = true;
    interval = "monthly";
  };
}

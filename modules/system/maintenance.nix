{
  lib,
  ...
}:
{

  # https://wiki.nixos.org/wiki/Automatic_system_upgrades
  system.autoUpgrade = lib.mkDefault {
    enable = true;
    flake = "/etc/nixos";
    allowReboot = true;
    rebootWindow = {
      lower = "01:00";
      upper = "05:00";
    };
    runGarbageCollection = true;
  };

  # Prevent boot from filling up
  boot.loader.grub.configurationLimit = 5;
}

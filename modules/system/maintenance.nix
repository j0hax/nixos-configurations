{
  config,
  pkgs,
  self,
  lib,
  ...
}:
{

  # https://wiki.nixos.org/wiki/Automatic_system_upgrades
  system.autoUpgrade = lib.mkDefault {
    enable = true;
    flake = self.outPath;
    allowReboot = true;
    runGarbageCollection = true;

  };

  # Prevent boot from filling up
  boot.loader.grub.configurationLimit = 5;

  /*
    Now done by `nh` command!
    nix = {
      gc = {
        automatic = true;
        options = "--delete-older-than 7d";
      };
      optimise.automatic = true;
    };
  */
}

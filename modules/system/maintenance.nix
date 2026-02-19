{
  config,
  pkgs,
  self,
  ...
}:
{
  system.autoUpgrade = {
    enable = true;
    flake = self.outPath;
    flags = [
      "--update-input"
      "nixpkgs"
      "-L" # print build logs
    ];
    allowReboot = false;
    runGarbageCollection = true;
    
  };

  # Prevent boot from filling up
  boot.loader.grub.configurationLimit = 5;

  nix = {
    gc = {
      automatic = true;
      options = "--delete-older-than 7d";
    };
    optimise.automatic = true;
  };
}

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
  };

  # Prevent boot from filling up
  boot.loader.grub.configurationLimit = 5;

  nix = {
    gc = {
      automatic = true;
      options = "--delete-older-than 2d";
      dates = [ "01:00" "13:00" ];
    };
    optimise.automatic = true;
  };
}

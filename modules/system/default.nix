{
  config,
  pkgs,
  ...
}:
{
  imports = [
    ./maintenance.nix
    ./networking.nix
    ./tmpfs.nix
  ];

  # Does NOT work with bcachefs yet...
  #boot.initrd.systemd.enable = true;

  boot.kernelParams = [ "mitigations=off" ];

  system.switch = {
    enable = false;
    enableNg = true;
  };

  zramSwap = {
    enable = true;
    algorithm = "zstd";
  };

  services.fstrim.enable = true;
}

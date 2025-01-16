{
  ...
}:
{
  imports = [
    ./maintenance.nix
    ./networking.nix
    ./tmpfs.nix
    ./kernel.nix
    ./virtualisation.nix
  ];

  # Does NOT work with bcachefs yet...
  #boot.initrd.systemd.enable = true;

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

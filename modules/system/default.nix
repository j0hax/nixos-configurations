{
  lib,
  config,
  ...
}:
let
  cfg = config.jka;
in
{
  imports = [
    ./maintenance.nix
    ./power.nix
    ./networking.nix
    ./tmpfs.nix
    ./kernel.nix
    ./virtualisation.nix
    ./packages.nix
    ./containers.nix
    ./documentation.nix
    ./environment.nix
    ./security.nix
    ./restic.nix
    ./services.nix
    ./mta.nix
    ./nix.nix
  ];

  config = {
    zramSwap = {
      enable = true;
      algorithm = "zstd";
    };

    users.motd = "Welcome to ${config.networking.hostName}!";
  };
}

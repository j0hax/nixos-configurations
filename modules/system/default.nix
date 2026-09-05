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
  ];

  options.jka.flakePath = lib.mkOption {
    type = lib.types.str;
    default = "/etc/nixos";
    description = "Path to the flake used by nh and auto-upgrade.";
  };

  config = {
    nix.settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
    };

    # Essential tool for helping
    programs.nh = {
      enable = true;
      flake = cfg.flakePath;
      clean = {
        enable = true;
        dates = "daily";
      };
    };

    zramSwap = {
      enable = true;
      algorithm = "zstd";
    };

    users.motd = "Welcome to ${config.networking.hostName}!";
  };
}

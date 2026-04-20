{
  lib,
  config,
  ...
}:
{
  imports = [
    ./maintenance.nix
    ./power.nix
    ./networking.nix
    ./tmpfs.nix
    ./kernel.nix
    #./virtualisation.nix
    ./packages.nix
    ./containers.nix
    ./documentation.nix
    ./environment.nix
    ./security.nix
    ./restic.nix
    ./services.nix
    ./mta.nix
  ];

  nix.settings = {
    # When using a tmpfs, /tmp is often too small:
    # https://github.com/NixOS/nixpkgs/issues/293114#issuecomment-2663470083
    # build-dir = "/var/tmp";

    # Needed for flakes
    experimental-features = [
      "nix-command"
      "flakes"
    ];
  };

  # Essential tool for helping
  programs.nh = {
    enable = true;
    flake = "/etc/nixos";
    clean.enable = true;
  };

  zramSwap = {
    enable = true;
    algorithm = "zstd";
  };

  users.motd = "Welcome to ${config.networking.hostName}!";
  
  # Causes problems with Firefox/Thunderbird
  #environment.memoryAllocator.provider = "mimalloc";
}

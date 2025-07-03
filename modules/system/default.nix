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
    ./containers.nix
    ./documentation.nix
    ./locale.nix
    ./security.nix
  ];

  nix.settings = {
    # When using a tmpfs, /tmp is often too small:
    # https://github.com/NixOS/nixpkgs/issues/293114#issuecomment-2663470083
    build-dir = "/var/tmp";

    # Needed for flakes
    experimental-features = [
      "nix-command"
      "flakes"
    ];
  };

  zramSwap = {
    enable = true;
    algorithm = "zstd";
  };

  services.fstrim.enable = true;

  # Causes problems with Firefox/Thunderbird
  #environment.memoryAllocator.provider = "mimalloc";
}

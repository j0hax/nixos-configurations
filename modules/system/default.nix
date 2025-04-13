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
  ];

  # Does NOT work with bcachefs yet...
  #boot.initrd.systemd.enable = true;

  # Locale settings
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.supportedLocales = [ "en_US.UTF-8/UTF-8" "de_DE.UTF-8/UTF-8"];
  i18n.extraLocaleSettings = {
    LC_MEASUREMENT = "de_DE.UTF-8";
    LC_MONETARY = "de_DE.UTF-8";
    LC_PAPER = "de_DE.UTF-8";
    LC_TELEPHONE = "de_DE.UTF-8";
    LC_TIME = "de_DE.UTF-8";
  };

  services.xserver.layout = "eu";

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

  system.switch = {
    enable = false;
    enableNg = true;
  };

  zramSwap = {
    enable = true;
    algorithm = "zstd";
  };

  services.fstrim.enable = true;

  # Causes problems with Firefox/Thunderbird
  #environment.memoryAllocator.provider = "mimalloc";
}

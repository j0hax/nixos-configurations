{
  config,
  pkgs,
  home-manager,
  ...
}:
{
  users.users.johannes = {
    description = "Johannes Karl Arnold";
    isNormalUser = true;
    shell = pkgs.fish;
    extraGroups = [
      "wheel"
      "video"
      "libvirtd"
      "dialout"
      "adbusers"
      "pcap"
    ];
  };

  # Enable decryption of Secrets with my key
  age.identityPaths = [ "${config.users.users.johannes.home}/.ssh/id_ed25519" ];

  # HM Stuff
  imports = [
    home-manager.nixosModules.home-manager
    {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.users.johannes = import ./home.nix;
    }
  ];
}

{
  config,
  pkgs,
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

  home-manager.users.johannes = import ./home.nix;

  # Enable decryption of Secrets with my key
  age.identityPaths = [ "${config.users.users.johannes.home}/.ssh/id_ed25519" ];

}

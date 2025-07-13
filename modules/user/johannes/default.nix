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

    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMotsR5BpofWuzmITfavGYN/+EjpEoPHgdRjCKCpbxkp jarnold@b1-systems.de"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKF6GqhZ0tmv16cwg7JKGb+cnWXqVE23xy+wBhA67Iwo jka.one"
    ];
  };

  home-manager.users.johannes = import ./home.nix;

  # Enable decryption of Secrets with my key
  age.identityPaths = [ "${config.users.users.johannes.home}/.ssh/id_ed25519" ];

}

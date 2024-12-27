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
    ];
  };

  # Enable decryption of Secrets with my key
  age.identityPaths = [ "${config.users.users.johannes.home}/.ssh/id_ed25519" ];
}

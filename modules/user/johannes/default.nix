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
    ];
    packages = with pkgs; [ 
      go
      rclone
    ];
  };

  age.identityPaths = [ "${config.users.users.johannes.home}/.ssh/id_ed25519" ];
}

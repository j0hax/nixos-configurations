{ config, ... }: {
  services.restic = {
    home = {
      repository = "/run/media/johannes/Backups";
      paths = [ "/home" "/root" ];
      passwordFile = "/etc/nixos/restic-password";
    };
  };
}

{ config, ... }: {
  services.restic.backups = {
    home = {
      repository = "/run/media/johannes/Backups";
      paths = [ "/home" "/root" ];
      passwordFile = "/etc/nixos/secrets/restic-password";
    };
  };
}

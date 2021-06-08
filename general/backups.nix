{ config, ... }:
{
  services.restic.backups = {
    essentials = {
      repository = "sftp:johannes@eldridge.lan:/data/backups/";
      paths = [ "/home" "/var/lib" ];
      extraBackupArgs = [ "--exclude-caches" ];
      initialize = true;
      passwordFile = "/root/restic-password";
    };
  };
}

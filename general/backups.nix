{ config, ... }:
{
  services.restic.backups = {
    essentials = {
      repository = "sftp:johannes@eldridge.lan:/data/backups/";
      paths = [ "/home" "/var/lib" ];
      extraBackupArgs = [ "--exclude-caches" ];
      pruneOpts = [
        "--keep-daily 7"
        "--keep-weekly 5"
        "--keep-monthly 12"
        "--keep-yearly 75"
      ];
      initialize = true;
      passwordFile = "/root/restic-password";
    };
  };
}

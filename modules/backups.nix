{ config, ... }:
let
  mainRepo = "/var/backups";

  passwordFile = "/etc/nixos/secrets/restic-password";

  # This tag marks backups initiated by the systemd service, NOT manually
  autoTag = "--tag service";

  pruneOpts =
    [ "--keep-daily 7" "--keep-weekly 4" "--keep-monthly 12" autoTag ];
in {
  # Save some typing ;)
  environment.variables = {
    RESTIC_REPOSITORY = mainRepo;
    RESTIC_PASSWORD_FILE = passwordFile;
  };

  services.restic.backups = {
    local = let user = "johannes";
    in {
      repository = mainRepo;
      initialize = true;
      inherit user;
      paths = [ "/home" ];
      inherit pruneOpts;
      extraBackupArgs = [ autoTag "--exclude-caches" ];
      inherit passwordFile;
    };
  };
}

{ config, pkgs, ... }:
let
  mainRepo = "/var/backups";

  passwordFile = "/etc/nixos/secrets/restic-password";

  # This tag marks backups initiated by the systemd service, NOT manually
  autoTag = "--tag service";

  pruneOpts =
    [ "--keep-daily 7" "--keep-weekly 4" "--keep-monthly 12" autoTag ];
in {
  environment = {
    systemPackages = [ pkgs.restic ];

    # Save some typing ;)
    variables = {
      RESTIC_REPOSITORY = mainRepo;
      RESTIC_PASSWORD_FILE = passwordFile;
    };
  };

  services.restic.backups.local = {
    repository = mainRepo;
    initialize = true;
    paths = [ "/home" ];
    inherit pruneOpts;
    extraBackupArgs = [ autoTag "--exclude-caches" ];
    inherit passwordFile;
  };
}

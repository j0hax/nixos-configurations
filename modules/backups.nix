{ config, ... }:
let
  mainRepo = "/var/backups";
  passwordFile = "/etc/nixos/secrets/restic-password";
in {
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
      paths = [ "/home/${user}/Documents" ];
      extraBackupArgs = [ "--tag service" ];
      inherit passwordFile;
    };
  };
}

{
  config,
  pkgs,
  ...
}:
{
  age.secrets = {
    "restic/env".file = ../secrets/restic/env.age;
    "restic/repo".file = ../secrets/restic/repo.age;
    "restic/password".file = ../secrets/restic/password.age;
  };

  services.restic.backups = {
    hourly = {
      environmentFile = config.age.secrets."restic/env".path;
      repositoryFile = config.age.secrets."restic/repo".path;
      passwordFile = config.age.secrets."restic/password".path;

      timerConfig = {
        OnCalendar = "hourly";
        Persistent = true;
      };

      inhibitsSleep = true;

      extraBackupArgs = [
        "--tag nix"
        "--one-file-system"
      ];

      paths = [
        "/home"
        "/etc"
      ];

      exclude = [
        "/home/*/.cache"
        "/home/*/Downloads"
      ];

      pruneOpts = [
        "--keep-daily 7"
        "--keep-weekly 5"
        "--keep-monthly 12"
        "--keep-yearly 10"
      ];
    };
  };
}

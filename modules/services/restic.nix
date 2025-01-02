{
  config,
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

      # https://github.com/NixOS/nixpkgs/issues/196547
      backupPrepareCommand = ''
        while ! /run/current-system/sw/bin/ping -c 1 1.0.0.1; do
          echo "Waiting for internet connection..."
          sleep 60
        done

        echo "Internet is up, uploading backups!"
      '';

      extraBackupArgs = [
        "--tag nix"
        "--one-file-system"
        "--exclude-larger-than 1G"
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
        "--keep-weekly 4"
        "--keep-monthly 12"
        "--keep-yearly 10"
        "--repack-uncompressed"
        "--compression max"
        "--max-unused 0"
      ];
    };
  };
}

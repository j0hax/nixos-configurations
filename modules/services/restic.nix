{
  config,
  sops,
  lib,
  ...
}:
{
  sops.secrets."restic/repository" = { };
  sops.secrets."restic/password" = { };
  sops.secrets.rclone = {
    sopsFile = ../../secrets/rclone-system.ini;
    format = "ini";
  };

  services.restic.backups = {
    storagebox = {
      repositoryFile = config.sops.secrets."restic/repository".path;
      passwordFile = config.sops.secrets."restic/password".path;
      rcloneConfigFile = config.sops.secrets.rclone.path;

      timerConfig = {
        OnCalendar = "daily";
        RandomizedDelaySec = "6h";
        persistent = "true";
      };

      inhibitsSleep = true;
      runCheck = true;

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
        "--verbose"
      ];

      paths = [
        "/home"
        "/etc"
        "/var"
      ];

      exclude = [
        # Most likely not needed
        "/home/*/.cache/"
        "/home/*/Downloads/"
        "/home/*/.local/"

        # Generally large/media files
        "*.mkv"
        "*.mp4"
        "*.part"
        "*.iso"
        "*.img"
        "*.qcow2"
      ];

      pruneOpts = [
        "--keep-daily 7"
        "--keep-weekly 5"
        "--keep-monthly 12"
        "--keep-yearly 10"
        "--repack-uncompressed"
        "--max-unused 0"
        "--keep-tag keep"
      ];
    };
  };
}

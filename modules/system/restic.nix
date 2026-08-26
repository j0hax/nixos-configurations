{
  config,
  sops,
  lib,
  pkgs,
  ...
}:
let
  minecraft = config.services.minecraft-server;
in

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
        "--retry-lock 1h"
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
        "*.png"
      ];

      checkOpts = [
        "--retry-lock 1h"
      ];

      pruneOpts = [
        "--keep-daily 7"
        "--keep-weekly 5"
        "--keep-monthly 12"
        "--keep-yearly 10"
        "--repack-uncompressed"
        "--max-unused 0"
        "--keep-tag keep"
        "--retry-lock 1h"
      ];
    };

    services.restic.backups.minecraft = lib.mkIf minecraft.enable {
      paths = [
        minecraft.dataDir
      ];

      repositoryFile = config.sops.secrets."restic/repository".path;
      passwordFile = config.sops.secrets."restic/password".path;
      rcloneConfigFile = config.sops.secrets.rclone.path;

      timerConfig = {
        OnCalendar = "hourly";
        RandomizedDelaySec = "6h";
        persistent = "true";
      };

      # Make the Restic service wait for the Minecraft save service.
      depends = [ "minecraft-save-before-backup.service" ];
    };
  };

  systemd.services.minecraft-save-before-backup =
    lib.mkIf minecraft.enable {
      description = "Flush Minecraft world before Restic backup";

      before = [ "restic-backups-minecraft.service" ];

      serviceConfig = {
        Type = "oneshot";
        User = "minecraft";
      };

      script = ''
        if ${pkgs.systemd}/bin/systemctl is-active --quiet minecraft-server.service; then
          echo "Flushing Minecraft world before backup..."
          echo "say Starting Backup..." > /run/minecraft-server.stdin
          echo "save-all flush" > /run/minecraft-server.stdin
        else
          echo "Minecraft server is not running; skipping save."
        fi
      '';
    };

  systemd.services.restic-backups-minecraft =
    lib.mkIf minecraft.enable {
      requires = [ "minecraft-save-before-backup.service" ];
      after = [ "minecraft-save-before-backup.service" ];
    };
}

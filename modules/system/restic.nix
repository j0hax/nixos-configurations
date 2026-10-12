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
  sops.secrets."restic/http/user" = { };    
  sops.secrets."restic/http/password" = { };
  
  sops.templates."restic-rest.env".content = ''
    RESTIC_REST_USERNAME=${config.sops.placeholder."restic/http/user"}
    RESTIC_REST_PASSWORD=${config.sops.placeholder."restic/http/password"}
  '';

  services.restic.backups = {
    system = {
      repositoryFile = config.sops.secrets."restic/repository".path;
      passwordFile = config.sops.secrets."restic/password".path;
      environmentFile = config.sops.templates."restic-rest.env".path;

      timerConfig = {
        OnCalendar = "daily";
        persistent = "true";
      };

      inhibitsSleep = true;
      runCheck = true;

      extraBackupArgs = [
        "--tag nix"
        "--one-file-system"
        "--verbose"
        "--skip-if-unchanged"
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
    };

    minecraft = lib.mkIf minecraft.enable {
      paths = [
        minecraft.dataDir
      ];

      repositoryFile = config.sops.secrets."restic/repository".path;
      passwordFile = config.sops.secrets."restic/password".path;
      environmentFile = config.sops.templates."restic-rest.env".path;

      extraBackupArgs = [
        "--tag nix"
        "--tag minecraft"
        "--skip-if-unchanged"
      ];

      backupPrepareCommand = ''
        echo "say [§6WARN§r] Starting backup..." > /run/minecraft-server.stdin
        sleep 1
        cat <<EOF > /run/minecraft-server.stdin
        save-off
        save-all flush
        EOF
      '';

      backupCleanupCommand = ''
        echo 'save-on' > /run/minecraft-server.stdin
        if [ "$SERVICE_RESULT" = "success" ]; then
          echo "say [§3INFO§r] Backup completed." > /run/minecraft-server.stdin
        else
          echo "say [§4ERROR§r] Backup had issues! ($SERVICE_RESULT: $EXIT_STATUS)" > /run/minecraft-server.stdin
        fi
      '';

      timerConfig = {
        OnCalendar = "*-*-* 00/4:00:00 Europe/Berlin";
        persistent = "true";
      };
    };
  };
}

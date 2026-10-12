{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.jka.services.restic-server;
in
{
  options.jka.services.restic-server = {
    enable = lib.mkEnableOption "Restic REST server";

    domain = lib.mkOption {
      type = lib.types.str;
      default = "jka.one";
      description = "Base domain for restic server.";
    };
  };

  config = lib.mkIf cfg.enable {
    jka.services.caddy.enable = true;

    # Grab shared HTTP user and password
    sops.secrets."restic/http/user" = { };
    sops.secrets."restic/http/password" = { };
    sops.secrets."rclone-restic" = {
      sopsFile = ../../secrets/rclone-restic.ini;
      format = "ini";
      restartUnits = [ "rclone-restic.service" ];
    };

    # Substitute --user and --pass flags with these environment variables
    sops.templates."rclone-restic.env".content = ''
      RCLONE_USER=${config.sops.placeholder."restic/http/user"}
      RCLONE_PASS=${config.sops.placeholder."restic/http/password"}
    '';

    systemd.sockets.rclone-restic = {
      description = "Unix socket for rclone Restic endpoint";

      wantedBy = [ "sockets.target" ];

      socketConfig = {
        ListenStream = "/run/rclone-restic.sock";
        SocketUser = "caddy";
        SocketGroup = "caddy";
        SocketMode = "0660";
        RemoveOnStop = true;
      };
    };

    systemd.services.rclone-restic = {
      description = "Restic REST server backed by Rclone";

      after = [ "network-online.target" ];
      wants = [ "network-online.target" ];

      serviceConfig = {
        DynamicUser = true;

        LoadCredential = [
          "rclone.conf:${config.sops.secrets."rclone-restic".path}"
        ];

        EnvironmentFile = config.sops.templates."rclone-restic.env".path;

        ExecStart = lib.escapeShellArgs [
          "${pkgs.rclone}/bin/rclone"
          "--config"
          "%d/rclone.conf"
          "serve"
          "restic"
          "backups:."
          # "--append-only"
          "--syslog"
          "-vv"
        ];

        Restart = "on-failure";
        RestartSec = "5s";
        UMask = "0077";
        NoNewPrivileges = true;
        PrivateTmp = true;
      };
    };

    services.caddy.virtualHosts."backups.${cfg.domain}" = {
      # inherit (cfg) serverAliases;
      extraConfig = ''
        encode
        reverse_proxy unix//run/rclone-restic.sock
      '';
    };

    ## REPOSITORY MAINTENANCE ##
    services.restic.backups.repo-maintenance = {
      repository = "rclone:backups:.";
      passwordFile = config.sops.secrets."restic/password".path;
      rcloneConfigFile = config.sops.secrets."rclone-restic".path;

      # Empty paths means no backup command is run.
      paths = [ ];

      pruneOpts = [
        # Retention policy
        "--keep-daily 7"
        "--keep-weekly 5"
        "--keep-monthly 12"
        "--keep-yearly 10"
        "--keep-tag keep"
        # Aggressive compaction
        "--max-unused 0"
        "--repack-uncompressed"
        "--compression max"
      ];

      # Check repository integrity and read a sample of pack data.
      checkOpts = [
        "--read-data-subset=10%"
      ];

      timerConfig = {
        OnCalendar = "Sun *-*-* 06:00:00 Europe/Berlin";
        persistent = "true";
      };
    };
  };
}

{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.jka.services.matrix;
  domain = cfg.domain;
  matrixDomain = "matrix.${domain}";
  socketPath = config.services.matrix-tuwunel.settings.global.unix_socket_path;

  element-web = pkgs.element-web.override {
    conf = {
      default_server_config = {
        "m.homeserver" = {
          "base_url" = "https://${matrixDomain}";
          "server_name" = domain;
        };
      };
    };
  };
in
{
  options.jka.services.matrix = {
    enable = lib.mkEnableOption "Matrix homeserver (tuwunel)";

    domain = lib.mkOption {
      type = lib.types.str;
      default = "fiducit.net";
      description = "Primary Matrix server domain.";
    };
  };

  config = lib.mkIf cfg.enable {
    jka.services.caddy.enable = true;

    # Aside from HTTP, open the old standard Matrix ports as well
    networking.firewall = {
      allowedTCPPorts = [
        8080
        8448
        7881
      ];
      allowedUDPPorts = [
        8080
        8848
      ];
      allowedUDPPortRanges = [
        {
          from = 50100;
          to = 50200;
        }
      ];
    };

    sops.secrets."tuwunel.env" = {
      sopsFile = ../../secrets/tuwunel.env;
      format = "dotenv";

      # Make sure the Tuwunel service can read it.
      owner = "tuwunel";
    };

    services.caddy.virtualHosts = {
      ${domain} = {
        serverAliases = [ domain ];
        extraConfig = ''
          encode

          @matrix path /.well-known/matrix/*
          handle @matrix {
            reverse_proxy unix/${socketPath}
          }

          # Redirect anything else to homepage.
          handle {
            redir https://johannes-arnold.de{uri}
          }
        '';
      };

      ${matrixDomain} = {
        serverAliases = [ "${matrixDomain}:8448" ];
        extraConfig = ''
          encode

          # Route all Matrix-related paths to tuwunel
          @matrix path /_matrix/* /_synapse/* /_tuwunel/* /.well-known/*
          reverse_proxy @matrix unix/${socketPath}

          # Serve Element Web Interface
          cache
          root * ${element-web}
          file_server
        '';
      };
    };

    services.matrix-tuwunel = {
      enable = true;
      settings = {
        global = {
          server_name = domain;
          allow_registration = false;
          trusted_servers = [
            "matrix.org"
            "matrix.uni-hannover.de"
            "tchncs.de"
            "hackint.org"
          ];
          well_known = {
            client = "https://${matrixDomain}";
            server = "${matrixDomain}:443";
            support_contact.johannes = {
              role = "m.role.admin";
              email_address = "johannes@arnold.onl";
              matrix_id = "@johannes:${domain}";
            };
            # livekit_url = rtcDomain;
          };

          ip_source = "rightmost_x_forwarded_for";
          rocksdb_allow_fallocate = false; # btrfs
          database_backup_path = "/var/backups/tuwunel";
          database_backups_to_keep = 7;

          # Quality of Life settings
          url_preview_domain_explicit_allowlist = [ "*" ];
          forget_forced_upon_leave = false;
          delete_rooms_after_leave = true;

          # Publicity Settings
          allow_public_room_directory_over_federation = true;
          allow_public_room_directory_without_auth = true;

          media_storage_providers = [
            "backblaze"
          ];
        };
      };
    };

    systemd =
      let
        backup_path = config.services.matrix-tuwunel.settings.global.database_backup_path;
      in
      {
        services.tuwunel.serviceConfig.ReadWritePaths = [
          backup_path
        ];

        # TODO: replace this option when 26.11 drops
        services.tuwunel.serviceConfig.EnvironmentFile = [
          config.sops.secrets."tuwunel.env".path
        ];

        tmpfiles.settings."tuwunel-backup".${backup_path}.d = {
          mode = "0700";
          user = "tuwunel";
          group = "tuwunel";
        };
      };
  };
}

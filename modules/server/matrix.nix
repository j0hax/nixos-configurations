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

    webhookDomain = lib.mkOption {
      type = lib.types.str;
      default = "events.fiducit.net";
      description = "Domain for Webhook Events";
    };

    webhookPort = lib.mkOption {
      type = lib.types.port;
      default = 9000;
      description = "Internal port used for webhooks.";
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

      # Pure Matrix communication subdomain
      ${matrixDomain} = {
        serverAliases = [ "${matrixDomain}:8448" ];
        extraConfig = ''
          encode
          reverse_proxy unix/${socketPath}
        '';
      };

      # Serve Element Web Interface
      "web.${matrixDomain}" = {
        extraConfig = ''
          encode

          handle /webhook/* {
            reverse_proxy localhost:9000
          }
          
          cache
          root * ${element-web}
          file_server
        '';
      };

      # Reverse proxy to hookshot events
      ${cfg.webhookDomain} = {
        extraConfig = ''
          encode
          reverse_proxy localhost:9000
        '';
      };
    };

    services.matrix-tuwunel = {
      enable = true;
      package = pkgs.unstable.matrix-tuwunel;
      settings = {
        global = {
          server_name = domain;
          unix_socket_path = "/run/tuwunel/tuwunel.sock";
          allow_registration = false;
          allow_legacy_media = true;
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

          auto_join_rooms = [
            "#lounge:fiducit.net"
          ];

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

      group = "caddy";
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

    sops.secrets.hookshot-reg = {
      sopsFile = ../../secrets/hookshot.yaml;
      key = "";
    };

    # Hookshot bot
    jka.services.redis.enable = true;
    services.matrix-hookshot = {
      enable = true;
      registrationFile = config.sops.secrets.hookshot-reg.path;
      settings = {
        bridge = {
          bindAddress = "127.0.0.1";
          inherit domain;
          port = 9993;
          url = "https://${matrixDomain}";
        };
        bot = {
          displayname = "Hookshot";
          avatar = ./1F916.svg;
        };
        encryption.storagePath = "./cryptostore/";
        cache.redisUri = "redis://127.0.0.1:6379";
        serviceBots = [{
          localpart = "feeds";
          displayname = "Feeds";
          avatar = ./E381.svg;
          prefix = "!feeds";
          service = "feeds";
        }];
        listeners = [
          {
            bindAddress = "0.0.0.0";
            port = 9002;
            resources = [
              "widgets"
            ];
          }
          {
            bindAddress = "0.0.0.0";
            port = 9000;
            resources = [
              "webhooks"
            ];
          }
        ];
        feeds = {
          enabled = true;
          pollIntervalSeconds = 600;
        };
        generic = {
          enabled = true;
          outbound = true;
          urlPrefix = "https://${cfg.webhookDomain}";
          waitForComplete = true;
          webhookResponse = true;
          allowJsTransformationFunctions= true;
        };
      };
    };
  };
}

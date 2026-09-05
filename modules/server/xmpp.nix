{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.jka.services.xmpp;
  domain = cfg.domain;
  sslCertDir = config.security.acme.certs.${domain}.directory;
in
{
  options.jka.services.xmpp = {
    enable = lib.mkEnableOption "XMPP server (Prosody + CoTURN)";

    domain = lib.mkOption {
      type = lib.types.str;
      default = "fiducit.net";
      description = "Primary XMPP domain.";
    };
  };

  config = lib.mkIf cfg.enable {
    jka.services.caddy.enable = true;
    jka.services.acme.enable = true;

    sops.secrets =
      let
        sopsFile = ../../secrets/xmpp.yaml;
      in
      {
        "turn/auth-secret" = {
          inherit sopsFile;
          owner = "turnserver";
          mode = "0444";
        };

        "ldap/rootdn" = {
          inherit sopsFile;
          format = "yaml";
        };

        "ldap/password" = {
          inherit sopsFile;
          format = "yaml";
        };
      };

    security.acme.certs.${domain} = {
      extraDomainNames = [
        "xmpp.${domain}"
        "conference.${domain}"
        "upload.${domain}"
        "pubsub.${domain}"
        "turn.${domain}"
      ];
      group = config.services.caddy.group;
      postRun = ''
        # set permission on dir
        ${pkgs.acl}/bin/setfacl -m \
        u:prosody:rx,u:turnserver:r \
        /var/lib/acme/${domain}

        # set permission on key file
        ${pkgs.acl}/bin/setfacl -m \
        u:prosody:r,u:turnserver:r \
        /var/lib/acme/${domain}/*.pem
      '';
      reloadServices = [
        "prosody"
        "coturn"
      ];
    };

    networking.firewall =
      let
        coturnPorts = with config.services.coturn; [
          listening-port
          alt-listening-port
          tls-listening-port
          alt-tls-listening-port
        ];
        coturnRelayPorts = with config.services.coturn; [
          {
            from = min-port;
            to = max-port;
          }
        ];
      in
      {
        allowedTCPPorts =
          [
            80
            443
            5222
            5269
            5280
            5281
          ]
          ++ lib.concatLists (
            with config.services.prosody;
            [
              httpPorts
              httpsPorts
            ]
          )
          ++ coturnPorts;

        allowedUDPPorts = coturnPorts;
        allowedUDPPortRanges = coturnRelayPorts;
      };

    sops.templates."extra-config.lua" = {
      owner = "prosody";
      content = ''
        -- LDAP Settings
        ldap_base = "ou=people,dc=jka,dc=one"
        ldap_server = "localhost:3890"
        ldap_rootdn = "${config.sops.placeholder."ldap/rootdn"}"
        ldap_password = "${config.sops.placeholder."ldap/password"}"

        -- TURN Settings
        turn_external_host = "turn.${domain}"
        turn_external_secret = "${config.sops.placeholder."turn/auth-secret"}"
      '';
    };

    boot.kernel.sysctl."net.ipv4.tcp_fastopen" = 3;

    services.prosody = {
      enable = true;

      package = pkgs.prosody.override {
        withCommunityModules = [
          "conversejs"
          "s2s_v6mesh"
          "unified_push"
          "pubsub_serverinfo"
          "sasl2"
          "sasl2_bind2"
          "sasl_ssdp"
          "sasl2_fast"
          "sasl2_sm"
          "sasl_ssdp"
          "csi_battery_saver"
          "muc_notifications"
        ];
        withExtraLuaPackages =
          p: with p; [
            luaevent
            luabitop
            luaunbound
            lualdap
            readline
          ];
      };

      admins = [
        "johannes@${domain}"
      ];
      allowRegistration = false;
      authentication = "ldap";
      s2sSecureAuth = true;
      c2sRequireEncryption = true;
      modules = {
        limits = true;
        server_contact_info = true;
        bosh = true;
        groups = true;
        motd = true;
        admin_adhoc = true;
        welcome = true;
        announce = true;
        websocket = true;
        watchregistrations = true;
      };
      extraModules = [
        "turn_external"
        "auth_ldap"
      ];

      xmppComplianceSuite = true;

      ssl = {
        cert = "${sslCertDir}/fullchain.pem";
        key = "${sslCertDir}/key.pem";
      };

      checkConfig = false;

      virtualHosts = {
        "myvhost0" = {
          domain = domain;
          enabled = true;
          extraConfig = ''
            pubsub_serverinfo_service = "pubsub.${domain}"

            Component "pubsub.${domain}" "pubsub"
            add_permissions = {
              ["prosody:registered"] = { "pubsub:create-node" }
            }

            Include "${config.sops.templates."extra-config.lua".path}"
          '';
        };
      };

      muc = [
        {
          domain = "conference.${domain}";
          restrictRoomCreation = "local";
        }
      ];

      extraConfig = ''
        storage = "sql"
        sql = {
          driver = "SQLite3";
          database = "prosody.sqlite";
        }

        network_settings = {
          tcp_fastopen = 256;
        }

        archive_expires_after = "never"
        muc_log_presences = true
        muc_log_expires_after = "never"

        smacks_max_queue_size = 4000

        conversejs_tags = {
          [[<script src="https://cdn.conversejs.org/3rdparty/libsignal-protocol.min.js"></script>]];
        }

        limits = {
          c2s = {
            rate = "3kb/s";
            burst = "2s";
          };
          s2sin = {
            rate = "30kb/s";
            burst = "3s";
          };
        }
      '';

      httpFileShare = {
        domain = "upload.${domain}";
        http_host = domain;
        expires_after = "never";
        size_limit = 1024 * 1024 * 1024;
      };
    };

    services.coturn = {
      enable = true;
      pkey = "${sslCertDir}/key.pem";
      cert = "${sslCertDir}/fullchain.pem";
      realm = "turn.${domain}";
      static-auth-secret-file = config.sops.secrets."turn/auth-secret".path;
      use-auth-secret = true;
    };
  };
}

{
  config,
  pkgs,
  lib,
  sops,
  ...
}:
let
  # sops.secrets."turn/auth-secret" = { };
  domain = "fiducit.net";
  sslCertDir = config.security.acme.certs."${domain}".directory;
  # turnSecret = config.sops.placeholder."turn/auth-secret";
in
{
  imports = [ ./caddy.nix ];
  sops.secrets."turn/auth-secret" = {
    owner = "turnserver";
    mode = "0444";
  };

  # Although I use Caddy's automatic HTTPS for most services,
  # we use the traditional ACME mechanisms on NixOS to get Prosody certificates.
  security.acme = {
    acceptTerms = true;
    defaults.email = "johannes@rnold.online";

    defaults.webroot = "/var/lib/acme/acme-challenge/";
    certs."${domain}" = {
      extraDomainNames = [
        "xmpp.${domain}"
        "conference.${domain}"
        "upload.${domain}"
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
  };

  services.caddy.virtualHosts = {
    # Unencrypted HTTPS Server on :80 is required for ACME challenges
    # All other queries are redirected to HTTPS
    "http://${domain}" = {
      serverAliases = [ "http://*.fiducit.net" ];
      extraConfig = ''
        handle_path /.well-known/* {
          root * /var/lib/acme/acme-challenge/
          file_server
        }

        handle {
          redir https://${domain}/conversejs
        }
      '';
    };

    # Serve HTTPS
    "https://${domain}" = {
      extraConfig = ''
        # Redirect regular queries to Converse.js
        redir / /conversejs

        # Use our custom ACME certificates as a reverse proxy endpoint
        tls ${sslCertDir}/fullchain.pem ${sslCertDir}/key.pem
        encode zstd gzip
        reverse_proxy 127.0.0.1:5280
      '';
    };
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
      allowedTCPPorts = [
        # HTTP filer
        80
        443

        # C2S
        5222
        5223

        # S2S
        5269
        5270

        # WebSockets / BOSH
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

  # Define a template for TURN Server credentials
  sops.templates."turn-config.lua" = {
    owner = "prosody";
    content = ''
      turn_external_host = "turn.${domain}"
      turn_external_secret = "${config.sops.placeholder."turn/auth-secret"}"
    '';
  };

  services.prosody = {
    enable = true;

    package = pkgs.prosody.override {
      withCommunityModules = [
        "conversejs"
        # Recommended by conversations.im and Monal
        # https://github.com/monal-im/Monal/wiki/Considerations-for-XMPP-server-admins
        "sasl2"
        "sasl2_bind2"
        "sasl_ssdp"
        "sasl2_fast"
        "sasl_ssdp"
        "csi_battery_saver"
        "muc_notifications"
      ];

    };

    admins = [
      "johannes@${domain}"
    ];
    allowRegistration = true;
    s2sSecureAuth = true;
    c2sRequireEncryption = true;
    modules = {
      http_files = true;
      limits = true;
      server_contact_info = true;
      bosh = true;
      motd = true;
      admin_adhoc = true;
      welcome = true;
      announce = true;
      websocket = true;
      watchregistrations = true;
    };
    extraModules = [
      # "csi_simple"
      "turn_external"
    ];

    xmppComplianceSuite = true;

    ssl = {
      cert = "${sslCertDir}/fullchain.pem";
      key = "${sslCertDir}/key.pem";
    };

    checkConfig = false;

    virtualHosts = {
      "myvhost0" = {
        domain = "${domain}";
        enabled = true;
        extraConfig = ''
          -- c2s_direct_tls_ports = { 5223 }
          -- s2s_direct_tls_ports = { 5270 }
          Include "${config.sops.templates."turn-config.lua".path}"
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

      -- Keep messages
      archive_expires_after = "never"
      muc_log_presences = true
      muc_log_expires_after = "never"

      -- Recommended by Monal dev
      smacks_max_queue_size = 4000
      

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
      size_limit = 32 * 1024 * 1024;
    };
  };

  # CoTURN for calls
  services.coturn = {
    enable = true;
    pkey = "${sslCertDir}/key.pem";
    cert = "${sslCertDir}/fullchain.pem";
    realm = "turn.${domain}";
    static-auth-secret-file = config.sops.secrets."turn/auth-secret".path;
    use-auth-secret = true;
  };
}

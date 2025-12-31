{
  config,
  pkgs,
  lib,
  ...
}:
let
  domain = "fiducit.net";
  sslCertDir = config.security.acme.certs."${domain}".directory;
in
{
  imports = [ ./caddy.nix ];

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
      ];
      group = config.services.caddy.group;
      postRun = ''
        # set permission on dir
        ${pkgs.acl}/bin/setfacl -m \
        u:prosody:rx \
        /var/lib/acme/${domain}

        # set permission on key file
        ${pkgs.acl}/bin/setfacl -m \
        u:prosody:r \
        /var/lib/acme/${domain}/*.pem
      '';
    };
  };

  services.caddy.virtualHosts."http://${domain}".extraConfig = ''
    root /.well-known/* /var/lib/acme/acme-challenge/
    file_server
  '';

  networking.firewall = {
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
    );
  };

  services.prosody = {
    # this is a minimal server config with turn and http upload
    # all server to server connection are blocked
    enable = true;
    admins = [
      "admin@${domain}"
      "johannes@${domain}"
    ];
    allowRegistration = false;
    s2sSecureAuth = true;
    c2sRequireEncryption = true;
    modules = {
      http_files = true;
      vcard = true;

      motd = true;
      admin_adhoc = true;
      welcome = true;
      announce = true;
      websocket = true;
      watchregistrations = true;
    };
    extraModules = [ "csi_simple" ];

    xmppComplianceSuite = true;

    ssl = {
      cert = "${sslCertDir}/fullchain.pem";
      key = "${sslCertDir}/key.pem";
    };

    virtualHosts = {
      # xmpp server for "@example.org" is hosted on "xmpp.example.org"
      # use SRV records.
      "myvhost0" = {
        domain = "${domain}";
        enabled = true;
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
        database = "prosody.sqlite"; -- The database name to use. For SQLite3 this the database filename (relative to the data storage directory).
      }
    '';

    httpFileShare = {
      domain = "upload.${domain}";
      http_host = domain;
    };
  };
}

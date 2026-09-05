{
  lib,
  pkgs,
  config,
  ...
}:
let
  cfg = config.jka.services.auth;
in
{
  options.jka.services.auth = {
    enable = lib.mkEnableOption "authentication services (LLDAP + Pocket ID)";

    domain = lib.mkOption {
      type = lib.types.str;
      default = "jka.one";
      description = "Base domain for auth services.";
    };

    ldapSubdomain = lib.mkOption {
      type = lib.types.str;
      default = "ldap";
      description = "Subdomain for LLDAP web UI.";
    };

    oidcSubdomain = lib.mkOption {
      type = lib.types.str;
      default = "auth";
      description = "Subdomain for Pocket ID OIDC.";
    };

    oidcPort = lib.mkOption {
      type = lib.types.port;
      default = 1411;
      description = "Internal port for Pocket ID.";
    };
  };

  config = lib.mkIf cfg.enable {
    jka.services.caddy.enable = true;

    # LLDAP — centralized user database
    services.caddy.virtualHosts."${cfg.ldapSubdomain}.${cfg.domain}" = {
      extraConfig = ''
        encode
        reverse_proxy 127.0.0.1:${toString config.services.lldap.settings.http_port}
      '';
    };

    sops.secrets.lldap = {
      sopsFile = ../../secrets/lldap.env;
      format = "dotenv";
    };

    services.lldap = {
      enable = true;
      settings = {
        http_url = "https://${cfg.ldapSubdomain}.${cfg.domain}";
        ldap_base_dn = "dc=jka,dc=one";
        ldap_user_pass_file = "/etc/lldap-pass";
        silenceForceUserPassResetWarning = false;
        force_ldap_user_pass_reset = "always";
      };
      environmentFile = config.sops.secrets.lldap.path;
    };

    # Pocket ID — OIDC provider
    services.caddy.virtualHosts."${cfg.oidcSubdomain}.${cfg.domain}" = {
      extraConfig = ''
        encode
        reverse_proxy 127.0.0.1:${toString cfg.oidcPort}
      '';
    };

    sops.secrets.pocket-id = {
      sopsFile = ../../secrets/pocket-id.env;
      format = "dotenv";
    };

    services.pocket-id = {
      enable = true;
      settings = {
        APP_URL = "https://${cfg.oidcSubdomain}.${cfg.domain}";
        TRUST_PROXY = true;
        PORT = cfg.oidcPort;
        UI_CONFIG_DISABLED = true;
        ACCENT_COLOR = "#40693A";
      };
      environmentFile = config.sops.secrets.pocket-id.path;
    };
  };
}

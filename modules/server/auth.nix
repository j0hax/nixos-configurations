{
  pkgs,
  config,
  sops,
  ...
}:
let
  domainBase = "jka.one";
  ldapDomain = "ldap.${domainBase}";
  port = 1411;
in
{
  imports = [ ./caddy.nix ];

  # LLDAP is used as a centralized user database

  services.caddy.virtualHosts.${ldapDomain} = {
    extraConfig = ''
      reverse_proxy 127.0.0.1:${toString config.services.lldap.settings.http_port}
    '';
  };

  # LLDAP suppprts passwords being set via environment variables,
  # but NixOS doesn't....
  /*
    sops.secrets."lldap-pass" = {
      sopsFile = ../../secrets/lldap-pass.txt;
      owner = "lldap";
      group = "lldap";
      key = "";
    };
  */

  sops.secrets.lldap = {
    sopsFile = ../../secrets/lldap.env;
    format = "dotenv";
  };

  services.lldap = {
    enable = true;
    settings = {
      http_url = "https://${ldapDomain}";
      ldap_base_dn = "dc=jka,dc=one";
      # ldap_user_pass_file = config.sops.secrets."lldap-pass".path;
      ldap_user_pass_file = "/etc/lldap-pass";
      silenceForceUserPassResetWarning = false;
      force_ldap_user_pass_reset = "always";
    };
    environmentFile = config.sops.secrets.lldap.path;
  };

  # Pocket ID is used to provide OIDC login

  services.caddy.virtualHosts."auth.${domainBase}" = {
    extraConfig = ''
      reverse_proxy 127.0.0.1:${toString port}
    '';
  };

  sops.secrets.pocket-id = {
    sopsFile = ../../secrets/pocket-id.env;
    format = "dotenv";
  };

  services.pocket-id = {
    enable = true;
    settings = {
      APP_URL = "https://auth.${domainBase}";
      TRUST_PROXY = true;
      PORT = port;

      UI_CONFIG_DISABLED = true;
      ACCENT_COLOR = "#40693A";
    };

    environmentFile = config.sops.secrets.pocket-id.path;
  };

}

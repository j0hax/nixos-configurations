{
  pkgs,
  config,
  sops,
  ...
}:
let
  domainBase = "jka.one";
  port = 1411;
in
{
  imports = [ ./caddy.nix ];

  # LLDAP is used as a centralized user database

  services.caddy.virtualHosts."ldap.${domainBase}" = {
    extraConfig = ''
      reverse_proxy ${config.services.lldap.settings.http_url}:${toString config.services.lldap.settings.http_port}
    '';
  };

  sops.secrets."ldap_user_pass" = {
    sopsFile = ../../secrets/lldap.yaml;
    owner = "lldap";
    group = "lldap";
  };

  services.lldap = {
    enable = true;
    settings = {
      ldap_base_dn = "dc=jka,dc=one";
      ldap_user_pass_file = config.sops.secrets."ldap_user_pass".path;
      force_ldap_user_pass_reset = "always";
    };
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

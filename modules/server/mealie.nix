{ config, sops, ... }:
{
  imports = [ ./caddy.nix ];

  services.caddy.virtualHosts."mealie.arnold.onl" = {
    serverAliases = [ "mealie.jka.one" ];
    extraConfig = ''
      encode
      reverse_proxy 127.0.0.1:${toString config.services.mealie.port}
    '';
  };

  sops.secrets.mealie = {
    sopsFile = ../../secrets/mealie.env;
    format = "dotenv";
  };

  services.mealie = {
    enable = true;
    # database.createLocally = true;
    settings = {
      BASE_URL = "https://mealie.arnold.onl";
      SQLITE_MIGRATE_JOURNAL_WAL = true;
    };
    extraOptions = [
      "--forwarded-allow-ips=127.0.0.1"
    ];
    credentialsFile = config.sops.secrets.mealie.path;
  };
}

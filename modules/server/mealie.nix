{ config, ... }:
{
  imports = [ ./caddy.nix ];

  services.caddy.virtualHosts."mealie.arnold.onl" = {
    serverAliases = [ "mealie.jka.one" ];
    extraConfig = ''
      encode
      reverse_proxy 127.0.0.1:${toString config.services.mealie.port}
    '';
  };

  services.mealie = {
    enable = true;
    # database.createLocally = true;
    settings = {
      BASE_URL = "mealie.arnold.onl";
      SQLITE_MIGRATE_JOURNAL_WAL = true;
    };
  };
}

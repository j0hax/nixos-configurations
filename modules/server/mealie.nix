{
  lib,
  config,
  ...
}:
let
  cfg = config.jka.services.mealie;
in
{
  options.jka.services.mealie = {
    enable = lib.mkEnableOption "Mealie recipe manager";

    domain = lib.mkOption {
      type = lib.types.str;
      default = "mealie.arnold.onl";
      description = "Primary domain for Mealie.";
    };

    serverAliases = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ "mealie.jka.one" ];
      description = "Additional domain aliases.";
    };
  };

  config = lib.mkIf cfg.enable {
    jka.services.caddy.enable = true;

    services.caddy.virtualHosts.${cfg.domain} = {
      inherit (cfg) serverAliases;
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
      settings = {
        BASE_URL = "https://${cfg.domain}";
        SQLITE_MIGRATE_JOURNAL_WAL = true;
      };
      extraOptions = [
        "--forwarded-allow-ips=127.0.0.1"
      ];
      credentialsFile = config.sops.secrets.mealie.path;
    };
  };
}

{
  lib,
  pkgs,
  config,
  ...
}:
let
  cfg = config.jka.services.caddy;
in
{
  options.jka.services.caddy = {
    enable = lib.mkEnableOption "Caddy reverse proxy";

    email = lib.mkOption {
      type = lib.types.str;
      default = "johannes@arnold.onl";
      description = "ACME email for Caddy.";
    };
  };

  config = lib.mkIf cfg.enable {
    services.caddy = {
      enable = true;
      package = pkgs.caddy.withPlugins {
        plugins = [ "github.com/caddyserver/cache-handler@v0.16.0" "github.com/mholt/caddy-l4@v0.1.2" ];
        hash = "sha256-O3ogEauP1vl10xTCSuVYcx4tGGEM3BH0o+lJh861+XA=";
      };
      inherit (cfg) email;
      globalConfig = ''
        cache {
          ttl 1h
          stale 24h
        }
      '';
    };

    networking.firewall = {
      allowedTCPPorts = [
        80
        443
      ];
      allowedUDPPorts = [ 443 ];
    };
  };
}

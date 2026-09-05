{
  lib,
  config,
  ...
}:
let
  cfg = config.jka.services.uptime;
in
{
  options.jka.services.uptime = {
    enable = lib.mkEnableOption "Uptime Kuma monitoring";

    domain = lib.mkOption {
      type = lib.types.str;
      default = "uptime.jka.one";
      description = "Domain for Uptime Kuma.";
    };

    port = lib.mkOption {
      type = lib.types.port;
      default = 5372;
      description = "Internal port for Uptime Kuma.";
    };
  };

  config = lib.mkIf cfg.enable {
    jka.services.caddy.enable = true;

    services.caddy.virtualHosts.${cfg.domain}.extraConfig = ''
      reverse_proxy 127.0.0.1:${toString cfg.port}
      encode zstd gzip
      header X-Robots-Tag "noindex, nofollow"
    '';

    services.uptime-kuma = {
      enable = true;
      settings = {
        UPTIME_KUMA_PORT = toString cfg.port;
      };
    };
  };
}

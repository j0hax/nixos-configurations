{
  lib,
  config,
  ...
}:
let
  cfg = config.jka.services.translate;
in
{
  options.jka.services.translate = {
    enable = lib.mkEnableOption "LibreTranslate translation server";

    domain = lib.mkOption {
      type = lib.types.str;
      default = "translate.jka.one";
      description = "Domain for LibreTranslate.";
    };
  };

  config = lib.mkIf cfg.enable {
    jka.services.caddy.enable = true;

    services.caddy.virtualHosts.${cfg.domain}.extraConfig = ''
      reverse_proxy 127.0.0.1:${toString config.services.libretranslate.port}
      cache
    '';

    services.libretranslate = {
      enable = true;
      domain = cfg.domain;
    };
  };
}

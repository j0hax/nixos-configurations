{
  lib,
  config,
  ...
}:
let
  cfg = config.jka.services.audiobookshelf;
in
{
  options.jka.services.audiobookshelf = {
    enable = lib.mkEnableOption "Audiobookshelf audiobook server";

    domain = lib.mkOption {
      type = lib.types.str;
      default = "audio.jka.one";
      description = "Domain for Audiobookshelf.";
    };

    port = lib.mkOption {
      type = lib.types.port;
      default = 6268;
      description = "Internal port for Audiobookshelf.";
    };
  };

  config = lib.mkIf cfg.enable {
    jka.services.caddy.enable = true;

    services.caddy.virtualHosts.${cfg.domain}.extraConfig = ''
      reverse_proxy 127.0.0.1:${toString cfg.port}
    '';

    services.audiobookshelf = {
      enable = true;
      port = cfg.port;
    };
  };
}

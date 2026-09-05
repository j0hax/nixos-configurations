{
  lib,
  config,
  ...
}:
let
  cfg = config.jka.services.navidrome;
in
{
  options.jka.services.navidrome = {
    enable = lib.mkEnableOption "Navidrome music streaming server";

    domain = lib.mkOption {
      type = lib.types.str;
      default = "music.jka.one";
      description = "Domain for Navidrome.";
    };

    musicFolder = lib.mkOption {
      type = lib.types.path;
      default = "/media/nextcloud/Music";
      description = "Path to the music library.";
    };
  };

  config = lib.mkIf cfg.enable {
    jka.services.caddy.enable = true;

    services.caddy.virtualHosts.${cfg.domain}.extraConfig = ''
      reverse_proxy 127.0.0.1:${toString config.services.navidrome.settings.Port}
      header X-Clacks-Overhead "GNU Ozzy Osbourne"
    '';

    services.navidrome = {
      enable = true;
      settings = {
        MusicFolder = cfg.musicFolder;
      };
    };
  };
}

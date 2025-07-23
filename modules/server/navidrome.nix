{ config, ... }:
{
  imports = [ ./caddy.nix ];

  services.caddy.virtualHosts."music.jka.one".extraConfig = ''
    reverse_proxy 127.0.0.1:${toString config.services.navidrome.settings.Port}
    header X-Clacks-Overhead "GNU Ozzy Osbourne"
  '';

  services.navidrome = {
    enable = true;
    settings = {
      MusicFolder = "/media/nextcloud/Music";
    };
  };
}

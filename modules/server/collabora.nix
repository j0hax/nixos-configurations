{ config, ... }:
{
  imports = [ ./caddy.nix ];

  services.caddy.virtualHosts."office.jka.one".extraConfig = ''
    reverse_proxy 127.0.0.1:${toString config.services.collabora-online.port}
  '';

  services.collabora-online = {
    enable = true;
  };
}

{ config, ... }:
{
  imports = [ ./caddy.nix ];

  services.caddy.virtualHosts."tty.jka.one".extraConfig = ''
    reverse_proxy 127.0.0.1:${toString config.services.ttyd.settings.port}
    encode zstd gzip
    header X-Robots-Tag "noindex, nofollow"
  '';


 
  services.ttyd = {
    enable = true;
      };
}

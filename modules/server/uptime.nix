{ config, ... }:
let
  hostname = "uptime.jka.one";
  port = "5372";
in {
  imports = [ ./caddy.nix ];

  services.caddy.virtualHosts.${hostname}.extraConfig = ''
    reverse_proxy 127.0.0.1:${port}
    encode zstd gzip
    header X-Robots-Tag "noindex, nofollow"
  '';

  services.uptime-kuma = {
    enable = true;
    settings = {
      UPTIME_KUMA_PORT = port;
    };
  };
}

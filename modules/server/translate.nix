{ config, ... }:
let
  domain = "translate.jka.one";
in
{
  imports = [ ./caddy.nix ];

  services.caddy.virtualHosts.${domain}.extraConfig = ''
    reverse_proxy 127.0.0.1:${toString config.services.libretranslate.port}
    cache
  '';

  services.libretranslate = {
    enable = true;
    inherit domain;
  };
}

{ ... }:
let
  port = 6268;
in {
  imports = [ ./caddy.nix ];

  services.caddy.virtualHosts."audio.jka.one".extraConfig = ''
    reverse_proxy 127.0.0.1:${toString port}
  '';

  services.audiobookshelf = {
    enable = true;
    inherit port;
  };
}

{ ... }:
{
  imports = [ ./caddy.nix ];

  services.caddy.virtualHosts."jellyfin.jka.one".extraConfig = ''
    reverse_proxy 127.0.0.1:8096
  '';

  services.jellyfin.enable = true;
}

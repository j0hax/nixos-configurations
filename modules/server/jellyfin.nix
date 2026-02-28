{ ... }:
let
  domainBase = "jka.one";
in {
  imports = [ ./caddy.nix ];

  services.caddy.virtualHosts."jellyfin.${domainBase}".extraConfig = ''
    serverAliases = [ "flix.${domainBase}" ];
    reverse_proxy 127.0.0.1:8096
  '';

  services.jellyfin.enable = true;
}

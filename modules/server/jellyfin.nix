{ ... }:
let
  domainBase = "jka.one";
in {
  imports = [ ./caddy.nix ];

  services.caddy.virtualHosts."jellyfin.${domainBase}" = {
    serverAliases = [ "flix.${domainBase}" ];
    extraConfig = ''
      reverse_proxy 127.0.0.1:8096
    '';
  };

  services.jellyfin.enable = true;
}

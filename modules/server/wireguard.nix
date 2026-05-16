{
  pkgs,
  lib,
  config,
  sops,
  ...
}:
let
  domainBase = "jka.one";
  port = 8000;
in
{
  imports = [ ./caddy.nix ];

  services.caddy.virtualHosts."wg.${domainBase}" = {
    serverAliases = [ "wireguard.${domainBase}" ];
    extraConfig = ''
      reverse_proxy 127.0.0.1:${toString port}
    '';
  };

  networking.firewall.allowedUDPPorts = [ 51820 ];

  systemd.services.wg-access-server.serviceConfig.User = "wg-access-server";

  sops.secrets.wg-access-server = {
    sopsFile = ../../secrets/wg-access-server.yaml;
    key = "";
  };

  networking.nat = {
    enable = true;
    enableIPv6 = true;
    externalInterface = "enp1s0";
    internalInterfaces = [ "wg0" ];
  };

  networking.firewall.trustedInterfaces = [ "wg0" ];

  services.wg-access-server = {
    enable = true;
    secretsFile = config.sops.secrets.wg-access-server.path;
    settings = {
      inherit port;
      clientConfig.PersistentKeepalive = 25;
      dns = {
        enabled = true;
        # AdGuard DNS
        upstream = [
          "94.140.14.14"
          "94.140.15.15"
          "2a10:50c0::ad1:ff"
          "2a10:50c0::ad2:ff"
        ];
      };
    };
  };

}

{
  lib,
  config,
  ...
}:
let
  cfg = config.jka.services.wireguard;
in
{
  options.jka.services.wireguard = {
    enable = lib.mkEnableOption "WireGuard VPN (wg-access-server)";

    domain = lib.mkOption {
      type = lib.types.str;
      default = "jka.one";
      description = "Base domain for the WireGuard web UI.";
    };

    port = lib.mkOption {
      type = lib.types.port;
      default = 8000;
      description = "Internal port for wg-access-server web UI.";
    };

    externalInterface = lib.mkOption {
      type = lib.types.str;
      default = "enp1s0";
      description = "External network interface for NAT.";
    };
  };

  config = lib.mkIf cfg.enable {
    jka.services.caddy.enable = true;

    services.caddy.virtualHosts."wg.${cfg.domain}" = {
      serverAliases = [ "wireguard.${cfg.domain}" ];
      extraConfig = ''
        encode
        reverse_proxy 127.0.0.1:${toString cfg.port}
      '';
    };

    networking.firewall.allowedUDPPorts = [ 51820 ];
    networking.firewall.trustedInterfaces = [ "wg0" ];

    systemd.services.wg-access-server.serviceConfig.User = "wg-access-server";

    sops.secrets.wg-access-server = {
      sopsFile = ../../secrets/wg-access-server.yaml;
      key = "";
    };

    networking.nat = {
      enable = true;
      enableIPv6 = true;
      inherit (cfg) externalInterface;
      internalInterfaces = [ "wg0" ];
    };

    services.wg-access-server = {
      enable = true;
      secretsFile = config.sops.secrets.wg-access-server.path;
      settings = {
        port = cfg.port;
        clientConfig.PersistentKeepalive = 25;
        dns = {
          enabled = true;
          upstream = [
            "94.140.14.14"
            "94.140.15.15"
            "2a10:50c0::ad1:ff"
            "2a10:50c0::ad2:ff"
          ];
        };
      };
    };
  };
}

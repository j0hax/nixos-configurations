{ pkgs, ... }:
let
  port = 5267;
  addr = "wg.jka.one";
in
{
  # networking.nat.enable = true;
  # networking.nat.externalInterface = "enp1s0";
  # networking.nat.internalInterfaces = [ "wg0" ];
  networking.firewall.allowedUDPPorts = [ 51820 ];
  boot.kernel.sysctl= {
  "net.ipv4.ip_forward" = 1;
  "net.ipv4.tcp_congestion_control"="bbr";
};
  /*
    networking.wg-quick.interfaces = {
      wg0 = {
        address = [ "10.0.0.1/24" ];
        listenPort = 51820;
        privateKeyFile = "/etc/wireguard/privatekey";

        peers = [
          {
            publicKey = "hyLhDEyI9Dxialfyc13Fs4j/ef1K+aTQ5tnu/wnXCEA=";
            allowedIPs = [ "10.0.0.2/32" ];
          }
          {
            publicKey = "B0R6dJt7NGpM6IsUJy77MXtikU/F8cJwAtt4zkzyVXc=";
            allowedIPs = [ "10.0.0.3/32" ];
          }
        ];
      };
    };
  */

  networking.firewall.trustedInterfaces = [ "wg0" ];

  networking.wireguard.interfaces = {
    wg0 = {
      ips = [ "10.0.0.1/24" ];
      listenPort = 51820;
      privateKeyFile = "/etc/wireguard/privatekey";
      peers = [
        {
          name = "aptenodytes";
          publicKey = "hyLhDEyI9Dxialfyc13Fs4j/ef1K+aTQ5tnu/wnXCEA=";
          allowedIPs = [ "10.0.0.2/32" ];
        }
        {
          name = "gruenaucam";
          publicKey = "B0R6dJt7NGpM6IsUJy77MXtikU/F8cJwAtt4zkzyVXc=";
          allowedIPs = [ "10.0.0.3/32" ];
        }
        {
          name = "pixel";
          publicKey = "X0kSkNPm071xtB2Ez9wqNf8bvWSifu0fUHtolIrrIhU=";
          allowedIPs = [ "10.0.0.4/32" ];
        }
      ];
    };
  };

  # networking.nftables.tables.wireguard-hub = {
  #   family = "inet";
  #   content = ''
  #     iifname $wg_iface oifname $wg_iface accept
  #   '';
  # };

  /*
    imports = [ ./caddy.nix ];

    services.caddy.virtualHosts.${addr}.extraConfig = ''
      reverse_proxy 127.0.01:${toString port}
      encode zstd gzip
      header X-Robots-Tag "noindex, nofollow"
      cache
    '';

    services.wg-access-server = {
      enable = true;
      settings = {
        port = port;
      };
      secretsFile = /etc/wireguard/wg-access-server-secrets.yaml;
    };
  */
}

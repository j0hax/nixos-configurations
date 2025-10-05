{
  pkgs,
  lib,
  config,
  ...
}:
let
  port = 5267;
  addr = "wg.jka.one";
in
{
  networking.firewall.allowedUDPPorts = [ 51820 ];

  # Needed to prevent conflichts with systemd-network
  networking.useNetworkd = true;

  # Wireguard Server with systemd-networkd
  systemd.network = {
    enable = true;
    netdevs = {
      "50-wg0" = {
        netdevConfig = {
          Kind = "wireguard";
          Name = "wg0";
        };

        wireguardConfig = {
          PrivateKeyFile = "/etc/wireguard/privatekey";
          ListenPort = 51820;
          RouteTable = "main"; # wg-quick creates routing entries automatically but we must use use this option in systemd.
        };

        wireguardPeers = [
          {
            PublicKey = "hyLhDEyI9Dxialfyc13Fs4j/ef1K+aTQ5tnu/wnXCEA=";
            AllowedIPs = [ "10.0.0.2/32" ];
          }
          {
            PublicKey = "zZWEMegtMvP9taLRtHXyRwQtfOUv9oooRG/06f1Be2U=";
            AllowedIPs = [ "10.0.0.3/32" ];
          }
          {
            PublicKey = "X0kSkNPm071xtB2Ez9wqNf8bvWSifu0fUHtolIrrIhU=";
            AllowedIPs = [ "10.0.0.4/32" ];
          }
          {
            PublicKey = "x9NBa/ywMCPa0fRIb7o86msAHOiGFzri/dLADG3Qnnw=";
            AllowedIPs = [
              "10.0.0.5/32"
              "192.168.1.0/24"
            ];
          }
        ];
      };
    };

    networks."wg0" = {
      matchConfig.Name = "wg0";
      address = [ "10.0.0.1/24" ];
      networkConfig = {
        IPMasquerade = "both";
        IPv4Forwarding = true;
        IPv6Forwarding = true;
      };
    };
  };
}

{
  pkgs,
  lib,
  config,
  ...
}:
let
  # Custom routing table number for the VPN
  Table = 666;

  # Function to repeatedly create a peer with an IP Address
  mkPeer = PublicKey: AllowedIPs: {
    inherit PublicKey;
    inherit AllowedIPs;
    PresharedKeyFile = "/etc/wireguard/preshared.key";
  };
in
{
  boot.kernel.sysctl = {
    "net.ipv4.ip_forward" = 1;
    "net.ipv6.conf.all.forwarding" = 1;
  };
  
  networking.firewall.allowedUDPPorts = [
    51820
  ];

  # Needed to prevent conflichts with systemd-network
  networking.useNetworkd = true;

  # Wireguard Server with systemd-networkd
  systemd.network = {
    enable = true;
    netdevs = {
      "private" = {
        netdevConfig = {
          Kind = "wireguard";
          Name = "wg0";
        };
        wireguardConfig = {
          PrivateKeyFile = "/etc/wireguard/privatekey";
          ListenPort = 51820;
        };
        wireguardPeers = [
          (mkPeer "hyLhDEyI9Dxialfyc13Fs4j/ef1K+aTQ5tnu/wnXCEA=" [ "10.0.0.2/32" ])
          (mkPeer "zZWEMegtMvP9taLRtHXyRwQtfOUv9oooRG/06f1Be2U=" [ "10.0.0.3/32" ])
          (mkPeer "X0kSkNPm071xtB2Ez9wqNf8bvWSifu0fUHtolIrrIhU=" [ "10.0.0.4/32" ])
          {
            PublicKey = "x9NBa/ywMCPa0fRIb7o86msAHOiGFzri/dLADG3Qnnw=";
            AllowedIPs = [
              "10.0.0.5/32"
              "192.168.1.0/24"
            ];
          }
          (mkPeer "3mojRZjAIMLyQr9JYi4qKKBGVM01fA8aqbtAjYx3xjY=" [ "10.0.0.6/32" ])
          (mkPeer "VWFc52Zjk2q2tkHFGPsL421QoW18r+cb66rbYmCtE0g=" [ "10.0.0.7/32" ])
        ];
      };
    };

    networks = {
      "private" = {
        matchConfig.Name = "wg0";
        address = [ "10.0.0.1/24" ];
        networkConfig = {
          IPMasquerade = "both";
          IPv4Forwarding = true;
          IPv6Forwarding = true;
        };
      };
    };
  };
}

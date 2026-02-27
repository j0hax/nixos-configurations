{
  config,
  pkgs,
  lib,
  ...
}:
  let yggdrasilPort = 1234;
in {

  networking = {
    nameservers = [
      "9.9.9.9"
      "149.112.112.112"
      "2620:fe::fe"
      "2620:fe::9"
    ];

    # Use nftables instead of iptables?
    # nftables.enable = true;

    wireguard.enable = true;
  };

  services.resolved = {
    enable = true;
    settings.Resolve = {
      DNSOverTLS = "opportunistic";
      DNSSEC = "allow-downgrade";
    };
  };

  programs.arp-scan.enable = true;

  environment.systemPackages = with pkgs; [
    dnsutils
    wireguard-tools
    nmap
  ];

  services.yggdrasil = {
    enable = true;
    persistentKeys = true;
    settings = {
      Listen = [
        "quic://0.0.0.0:${toString yggdrasilPort}"
        "tls://0.0.0.0:${toString yggdrasilPort}"
      ];
      Peers = lib.mkDefault [
        "quic://ygg1.mk16.de:1339?key=0000000087ee9949eeab56bd430ee8f324cad55abf3993ed9b9be63ce693e18a"
        "quic://ygg2.mk16.de:1339?key=000000d80a2d7b3126ea65c8c08fc751088c491a5cdd47eff11c86fa1e4644ae"
        "tls://91.98.126.143:32000"
        "tls://ygg.mkg20001.io:443"
      ];
    };
  };

  networking.firewall = {
    allowedUDPPorts = [ yggdrasilPort ];
    allowedTCPPorts = [ yggdrasilPort ];
  };
}

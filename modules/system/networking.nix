{
  config,
  pkgs,
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
      ];
      Peers = [
        "quic://bode.theender.net:42269"
        "tls://91.98.126.143:32000"
        "tls://ygg.mkg20001.io:443"
      ];
    };
  };

  networking.firewall = {
    allowedUDPPorts = [ yggdrasilPort ];
  };
}

{
  config,
  pkgs,
  ...
}:
{
  services.mullvad-vpn = {
    enable = true;
    enableExcludeWrapper = true;
  };

  # We want NetworkManager + encrypted DNS
  networking.networkmanager = {
    enable = true;
    wifi.backend = "iwd";
    dns = "systemd-resolved";
  };

  /*
    networking.nameservers = [
      "1.1.1.1#one.one.one.one"
      "1.0.0.1#one.one.one.one"
    ];
  */
  networking.nameservers = [
    "9.9.9.9"
    "149.112.112.112"
  ];

  services.resolved = {
    enable = true;
    dnssec = "true";
    dnsovertls = "opportunistic";
    fallbackDns = [
      "9.9.9.9#dns.quad9.net"
      "149.112.112.112#dns.quad9.net"
      "1.1.1.1#one.one.one.one"
      "1.0.0.1#one.one.one.one"
    ];
    domains = [ "~." ];
  };

  environment.systemPackages = [ pkgs.dnsutils ];
}
